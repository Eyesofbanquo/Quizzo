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
  // MARK: - State: Environment -
  @EnvironmentObject var handler: MLGame
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  @EnvironmentObject private var questionService: QuestionService

  // MARK: - State: Local -
  @State private var selectedCorrectAnswerChoices: [UUID] = []
  @State private var answerChoices: [Answer] = []
  @State private var hasEnoughAnswerChoices: Bool = true
  @State private var hasEnoughQuestions: Bool = true
  @State private var noEmptyAnswerChoices: Bool = true
  @State private var deleteAnswerChoice: Bool = false
  
  // MARK: - State: Injected -
  @Binding var questionName: String
  
  func isSelectedAnswerChoice(_ id: UUID) -> Bool {
    selectedCorrectAnswerChoices.contains(id)
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
          
          let question = Question(name: questionName, choices: modifiedAnswerChoices, player: handler.user?.displayName ?? "")
          
          questionService.appendQuestion(question: question, inGame: &handler.gameData)
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
              feedbackGen.light()
              try await handler.sendData()
              handler.setState(.inQuestion(playState: .showQuestion(gameData: handler.gameData, isCurrentPlayer: false)))
            }
            
          }
        } ) {
          Text("Submit question")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16.0)
                          .fill(Theme.LightGreen))
            
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
    QuestionViewEditingBody(questionName: .constant("MarkiM"))
      .environmentObject(MLGame())
      .environmentObject(FeedbackGenerator())
  }
}
