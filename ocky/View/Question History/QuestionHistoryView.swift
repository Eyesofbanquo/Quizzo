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
  var correctQuestion: Bool
  
  func randomIncorrectEmoji() -> String {
    let emoji = ["😭", "😪", "😅", "😐", "😴", "😓", "😬"]
    return emoji.randomElement()!
  }
  
  // MARK: - Layout -
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      if isCurrentQuestion {
        VStack(spacing: 16.0) {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .tint(Theme.Light)
            .scaleEffect(1.5)
          Text("Question is currently being played...")
            .font(.title2)
            .bold()
            .foregroundColor(Theme.Light)
        }
        .padding()
      } else {
        ScrollView {
          VStack(alignment: .leading) {
            HStack {
              Text("\(GKLocalPlayer.local.displayName)'s question")
                .font(.title)
                .bold()
                .foregroundColor(Theme.Light)
              Spacer()
            }
            Text("\(correctQuestion ? "Correct! 👏" : "Incorrect \(randomIncorrectEmoji())") Played by \(playedBy)")
              .font(.headline)
              .foregroundColor(Theme.Light)
            HStack {
              Text("Question \(questionIdx + 1)")
                .font(.subheadline)
                .foregroundColor(Theme.Light)
              Spacer()
            }
          }
          LazyVStack {
            ForEach(question.choices) { choice in
              VStack {
                Text(choice.text)
                  .questionButton(isHighlighted: choice.isCorrect, defaultBackgroundColor: Theme.LightBlue, highlightedColor: Theme.LightGreen)
              }
            }
          }
        }
        .navigationTitle("Game # \(String(matchID.prefix(4)))")
        .padding()
      }
    }
  }
}

struct QuestionHistoryViewView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionHistoryView(matchID: "123",
                        questionIdx: 1,
                        question: Question.stub,
                        isCurrentQuestion: false,
                        playedBy: "Kyrinne", correctQuestion: false)
  }
}
