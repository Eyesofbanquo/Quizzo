//
//  QuestionViewPlayingBody.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionViewPlayingBody: View {
  @EnvironmentObject var handler: MLGame
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  @State private var answerChoices: [Answer] = []
  @State private var submittedAnswer: Bool = false
  
  @EnvironmentObject var questionService: QuestionService
  
  var selectedAnswerIDs: [UUID] {
    answerChoices.map { $0.id }
  }
  
  var question: Question?
  
  var body: some View {
    VStack(alignment: .center) {
      ForEach(question?.choices ?? []) { choice in
        Button(action: {
          withAnimation {
            if self.selectedAnswerIDs.contains(choice.id) == false {
              self.answerChoices.append(choice)
            } else {
              self.answerChoices = self.answerChoices.filter { $0.id != choice.id}
            }
          }
        }) {
          Text(choice.text)
            .questionButton(isHighlighted: selectedAnswerIDs.contains(choice.id), defaultBackgroundColor: Theme.LightBlue,
                            highlightedColor: Theme.Yellow)
            .animation(.easeInOut, value: answerChoices)
        }
      }
      Button(action: {
        if handler.isUserTurn {
          if let question = question, let player = handler.user {
            /* Updated player info by sending it to the realm on grade */
            questionService.grade(currentQuestion: question, usingAnswerChoices: answerChoices, forPlayer: player, andGame: handler.activeMatch)
            handler.setState(.result(question: question, answers: answerChoices))
          }
        }
      }) {
        Text("Play turn")
          .foregroundColor(Theme.Light)
          .padding()
          .padding(.horizontal)
          .background(RoundedRectangle(cornerRadius: 16.0)
                        .fill(Theme.LightGreen))
      }
      .animation(.easeInOut, value: submittedAnswer)
      .disabled(submittedAnswer)
    }
  }
}

struct QuestionViewPlayingBody_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewPlayingBody(question: .stub)
      .environmentObject(MLGame())
      .environmentObject(FeedbackGenerator())
  }
}
