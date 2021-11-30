//
//  QuestionViewHeader.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI
import GameKit

struct QuestionViewStaticHeader: View {

  var matchID: String
  var matchStatus: GKTurnBasedMatch.Status
  var currentPlayerDisplayName: String
  var questionIndex: Int
  var questionViewState: QuestionViewState
  var isMultipleChoice: Bool
  
  var questionNumber: Int {
    questionIndex + 1
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Game ID #" + matchID)
          .font(.title)
          .bold()
        Spacer()
      }
      if matchStatus != .matching {
        Text("\(currentPlayerDisplayName)'s turn")
          .font(.headline)
      }
      HStack {
        Image(systemName: isMultipleChoice ? "die.face.6.fill" : "die.face.1.fill")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 24, height: 24)
          .foregroundColor(Theme.Light)
        Text("Question \(questionNumber)")
          .font(.subheadline)
          .foregroundColor(Theme.Light)
        Spacer()
      }
    }
    .foregroundColor(Theme.Light)
  }
}

struct QuestionViewStaticHeader_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewStaticHeader(
      matchID: "123",
      matchStatus: .open,
      currentPlayerDisplayName: "Markim",
      questionIndex: 1,
      questionViewState: .playing,
      isMultipleChoice: false)
      .previewLayout(.sizeThatFits)
  }
}
