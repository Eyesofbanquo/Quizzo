//
//  QuestionViewEditingBody.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionViewEditingBody: View {
  @EnvironmentObject var handler: MLGame
  @State private var selectedCorrectAnswerChoices: [UUID] = []
  @State private var questionName: String = ""
  @State private var answerChoices: [Answer] = []
  
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
        }
      } // loop
      
      Text("Press check mark to signal correct answer(s)")
        .fixedSize(horizontal: false, vertical: true)
      if answerChoices.count < 2 {
        Text("Add \(2 - answerChoices.count) more answer choice\(2 - answerChoices.count == 1 ? "" : "s")")
          .font(.subheadline)
          .foregroundColor(.red)
      }
      Button(action: {
        answerChoices.append(.empty)
      }) {
        Text("Add new answer choice")
          .foregroundColor(.white)
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
        
        let question = Question(name: questionName, choices: modifiedAnswerChoices)
        handler.appendQuestion(question: question)
        Task {
          try await handler.sendData()
        }
      } ) {
        Text("Submit question")
          .foregroundColor(.white)
          .padding()
          .background(RoundedRectangle(cornerRadius: 16.0))
      }
    }
  }
}

struct QuestionViewEditingBody_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewEditingBody()
      .environmentObject(MLGame())
  }
}
