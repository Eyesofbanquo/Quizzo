//
//  QuestionViewEditingBody.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionViewEditingBody: View {
  // MARK: - State: Environment -
  @EnvironmentObject var handler: MLGame
  @EnvironmentObject private var questionService: QuestionService

  // MARK: - State: Local -
  @State private var selectedCorrectAnswerChoices: [UUID] = []
  @State private var answerChoices: [Answer] = []
  @State private var hasEnoughAnswerChoices: Bool = true
  @State private var hasEnoughQuestions: Bool = true
  @State private var noEmptyAnswerChoices: Bool = true
  
  // MARK: - State: Injected -
  @Binding var questionName: String
  
  // MARK: - Layout -
  var body: some View {
    VStack {
      ForEach(0..<answerChoices.count, id: \.self) { idx in
        HStack {
          CheckboxField(id: answerChoices[idx].id) { id, enabled in
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
            .disableAutocorrection(true)
            .textFieldStyle(.roundedBorder)
            .padding()
            .submitLabel(determineSubmitLabelType(idx: idx))
        }
      } // loop
      
      // MARK: - Error Messages: Begin -
      Text("Press check mark to signal correct answer(s)")
        .font(.subheadline)
        .foregroundColor(.red)
        .fixedSize(horizontal: false, vertical: true)
        .opacity(hasEnoughAnswerChoices ? 0.0 : 1.0)
      
      Text("Make sure each answer choice is not blank")
        .font(.subheadline)
        .foregroundColor(.red)
        .fixedSize(horizontal: false, vertical: true)
        .opacity(hasEnoughAnswerChoices ? 0.0 : 1.0)
      
      if answerChoices.count < 2 {
        Text("Add \(2 - answerChoices.count) more answer choice\(2 - answerChoices.count == 1 ? "" : "s")")
          .font(.subheadline)
          .foregroundColor(.red)
      }
      // MARK: - Error Messages: End -
      
      VStack {
        Button(action: {
          answerChoices.append(.empty)
        }) {
          Text("Add new answer choice")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16.0))
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
              try await handler.sendData()
              handler.setState(.inQuestion(playState: .showQuestion(gameData: handler.gameData, isCurrentPlayer: false)))
            }
            
          }
        } ) {
          Text("Submit question")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: 16.0))
            
        }
      }
      .fixedSize(horizontal: true, vertical: false)
      
    }
  }
}

struct QuestionViewEditingBody_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewEditingBody(questionName: .constant("MarkiM"))
      .environmentObject(MLGame())
  }
}

extension QuestionViewEditingBody {
  private func determineSubmitLabelType(idx: Int) -> SubmitLabel {
    idx == answerChoices.count ? .done : .next
  }
}
