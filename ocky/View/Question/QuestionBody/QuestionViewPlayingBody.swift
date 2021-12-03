//
//  QuestionViewPlayingBody.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionViewPlayingBody: View {
  // MARK: -  State: Env -
  @EnvironmentObject var handler: MLGame
  @EnvironmentObject var feedbackGen: FeedbackGenerator
  @EnvironmentObject var questionService: QuestionService
  
  // MARK: - State: Local
  @State private var answerChoices: [Answer] = []
  @State private var submittedAnswer: Bool = false
  
  // MARK: - Props -
  var question: Question?
  
  // MARK: - Actions -
  var playTurnAction: (_ question: Question?, _ answerChoices: [Answer]) -> Void
  
  var selectedAnswerIDs: [UUID] {
    answerChoices.map { $0.id }
  }
  
  init(question: Question?, playTurnAction: @escaping (Question?, [Answer]) -> Void) {
    self.question = question
    self.playTurnAction = playTurnAction
  }
  
  init<T: PlayingBodyInput>(input: T) {
    self.question = input.question
    self.playTurnAction = input.playTurnAction
  }
  
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
        playTurnAction(question, answerChoices)
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
    QuestionViewPlayingBody(question: .stub, playTurnAction: { _, _ in })
      .environmentObject(MLGame())
      .environmentObject(FeedbackGenerator())
  }
}
