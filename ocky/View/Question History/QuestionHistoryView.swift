//
//  QuestionOtherUserResultsView.swift
//  ocky
//
//  Created by Markim Shaw on 11/23/21.
//

import SwiftUI
import GameKit

struct QuestionHistoryView: View {
  // MARK: - State -
  
  // MARK: - Inject -
  var matchID: String
  var questionIdx: Int
  var question: Question
  var isCurrentQuestion: Bool
  var playedBy: String
  
  // MARK: - Layout -
  var body: some View {
    if isCurrentQuestion {
      VStack(spacing: 16.0) {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .tint(.white)
          .scaleEffect(1.5)
        Text("Question is currently being played...")
          .font(.title2)
          .bold()
          .foregroundColor(Color(uiColor: .label))
      }
      .padding()
    } else {
      ScrollView {
//        QuestionViewHeader(matchID: String(matchID.prefix(4)), matchStatus: .open, currentPlayerDisplayName: question.player, questionIndex: questionIdx, questionViewState: .history)
        VStack(alignment: .leading) {
          HStack {
            Text("\(GKLocalPlayer.local.displayName)'s question")
              .font(.title)
              .bold()
            Spacer()
          }
          Text("Played by \(playedBy)")
            .font(.headline)
          HStack {
            Text("Question \(questionIdx + 1)")
              .font(.subheadline)
              .foregroundColor(Color.pink)
            Spacer()
          }
        }
        LazyVStack {
          ForEach(question.choices) { choice in
            Text(choice.text)
              .questionButton(isHighlighted: choice.isCorrect)
          }
        }
      }
      .navigationTitle("Game # \(String(matchID.prefix(4)))")
      .padding()
    }
  }
}

struct QuestionHistoryViewView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionHistoryView(matchID: "123",
                        questionIdx: 1,
                        question: Question.stub,
                        isCurrentQuestion: false,
                        playedBy: "Kyrinne")
  }
}
