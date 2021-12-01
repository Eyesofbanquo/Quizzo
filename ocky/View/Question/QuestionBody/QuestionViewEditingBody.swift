//
//  QuestionViewEditingBody.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct MLRoundedTextFieldStyle: TextFieldStyle {
  var color: Color
  func _body(configuration: TextField<Self._Label>) -> some View {
    configuration
      .padding(8)
      .background(
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .stroke(color, lineWidth: 1)
      )
  }
}

struct QuestionViewEditingBody: View {
  @Environment(\.colorScheme) var colorScheme
  // MARK: - State: Environment -
  @EnvironmentObject var feedbackGen: FeedbackGenerator

  // MARK: - State: Local -
  @State private var selectedCorrectAnswerChoices: [UUID] = []
  @State private var answerChoices: [Answer] = []
  @State private var hasEnoughAnswerChoices: Bool = true
  @State private var hasEnoughQuestions: Bool = true
  @State private var noEmptyAnswerChoices: Bool = true
  @State private var deleteAnswerChoice: Bool = false
  @State private var submittedAnswerChoice: Bool = false
  
  // MARK: - State: Injected -
  @Binding var questionName: String
  var currentPlayer: String
  
  // MARK: - Actions -
  var addQuestionToHistory: (Question) -> Void
  var endTurn: () -> Void
  
  @Binding var isMultipleChoiceBinding: Bool
  
  func isSelectedAnswerChoice(_ id: UUID) -> Bool {
    selectedCorrectAnswerChoices.contains(id)
  }
  
  init(questionName: Binding<String>,
       currentPlayer: String,
       addQuestionToHistory: @escaping (Question) -> Void,
       endTurn: @escaping () -> Void,
       isMultipleChoiceBinding: Binding<Bool>) {
    self.currentPlayer = currentPlayer
    self._questionName = questionName
    self.addQuestionToHistory = addQuestionToHistory
    self.endTurn = endTurn
    self._isMultipleChoiceBinding = isMultipleChoiceBinding
  }
  
  init<T: EditingBodyInput>(input: T) {
    self.init(questionName: input.questionName, currentPlayer: input.currentPlayer, addQuestionToHistory: input.addQuestionToHistory, endTurn: input.endTurn, isMultipleChoiceBinding: input.isMultipleChoiceBinding)
  }
  
  // MARK: - Layout -
  var body: some View {
    VStack {
      
      ForEach(0..<answerChoices.count, id: \.self) { idx in
        HStack {
          CheckboxField(id: answerChoices[idx].id, color: isSelectedAnswerChoice(answerChoices[idx].id) ? Theme.Yellow : Theme.Light) { id, enabled in
            
            feedbackGen.light()
            
            if enabled {
              selectedCorrectAnswerChoices.append(id)
            } else {
              selectedCorrectAnswerChoices = selectedCorrectAnswerChoices.filter { $0 != id}
            }
            
            withAnimation {
              isMultipleChoiceBinding = selectedCorrectAnswerChoices.count > 1
            }
          }
          TextField(answerChoices[idx].text, text: Binding<String>(get: {
            answerChoices[idx].text
          }, set: { val in
            answerChoices[idx].text = val
          }), prompt: Text("Enter an answer choice")
                      .foregroundColor(Color.gray)
                      .font(.headline))
            .foregroundColor(Theme.Light)
            .disableAutocorrection(false)
            .textFieldStyle(MLRoundedTextFieldStyle(color: isSelectedAnswerChoice(answerChoices[idx].id) ? Theme.Yellow : Theme.Light))
            .padding(4.0)
            
          
          Button(action: {
            /* Handle action. Present alert */
            feedbackGen.warning()
            deleteAnswerChoice.toggle()
          }) {
            Image(systemName: "xmark")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 16, height: 16)
              .foregroundColor(Theme.Red)
          }
          .alert("Delete this answer choice?", isPresented: $deleteAnswerChoice) {
            Button("Confirm", role: .destructive) {
              withAnimation {
                answerChoices = answerChoices.filter { $0.id != answerChoices[idx].id }
              }
            }
            Button("Cancel", role: .cancel) { }
          }
        } // hstack
      } // loop
      
      // MARK: - Error Messages: Begin -
      if !hasEnoughAnswerChoices {
        Text("Press check mark to signal correct answer(s)")
          .font(.subheadline)
          .foregroundColor(Theme.Red)
          .fixedSize(horizontal: false, vertical: true)
      }
      
      if !noEmptyAnswerChoices {
        Text("Make sure each answer choice is not blank")
          .font(.subheadline)
          .foregroundColor(Theme.Red)
          .fixedSize(horizontal: false, vertical: true)
      }
      
      
      if answerChoices.count < 2 {
        Text("Add \(2 - answerChoices.count) more answer choice\(2 - answerChoices.count == 1 ? "" : "s")")
          .font(.subheadline)
          .foregroundColor(Theme.Red)
      }
      // MARK: - Error Messages: End -
      
      VStack {
        Button(action: {
          withAnimation {
            answerChoices.append(.empty)
          }
        }) {
          Text("Add new answer choice")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16.0)
                          .fill(Theme.LightBlue))
        }
        Button(action: {
          let modifiedAnswerChoices = answerChoices.map { choice -> Answer in
            if selectedCorrectAnswerChoices.contains(choice.id) {
              return Answer(isCorrect: true, text: choice.text)
            }
            return choice
          }
          
          /* Return from this action if there are empty answer choices*/
          if modifiedAnswerChoices.contains(where: { $0.text.isEmpty }) {
            withAnimation {
              noEmptyAnswerChoices = false
            }
            return
          } else {
            withAnimation {
              noEmptyAnswerChoices = true
            }
          }
          
          let question = Question(name: questionName, choices: modifiedAnswerChoices, player: currentPlayer)
          
          addQuestionToHistory(question)
          
          Task {
            if selectedCorrectAnswerChoices.isEmpty  {
              withAnimation {
                hasEnoughAnswerChoices = false
              }
            }
            
            if questionName.isEmpty {
              withAnimation {
                hasEnoughQuestions = false
              }
            }
            
            if !questionName.isEmpty && (selectedCorrectAnswerChoices.count > 0 && modifiedAnswerChoices.count > 1) {
              withAnimation {
                submittedAnswerChoice.toggle()
              }
              feedbackGen.light()
              endTurn()
            }
            
          }
        } ) {
          
          HStack(spacing: 8.0) {
            if submittedAnswerChoice {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
            }
            Text("Submit question")
          }
          .foregroundColor(Theme.Light)
          .frame(maxWidth: .infinity)
          .padding()
          .background(RoundedRectangle(cornerRadius: 16.0)
                        .fill(Theme.LightGreen))
          .padding()
        }
      }
      .fixedSize(horizontal: true, vertical: false)
      .padding(.top, 4.0)
      .onAppear {
        feedbackGen.warm()
      }
    }
  }
}

struct QuestionViewEditingBody_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewEditingBody(questionName: .constant("MarkiM"),
                            currentPlayer: "MarkiM",
                            addQuestionToHistory: {_ in },
                            endTurn: {}, isMultipleChoiceBinding: .constant(true))
      .environmentObject(FeedbackGenerator())
  }
}
