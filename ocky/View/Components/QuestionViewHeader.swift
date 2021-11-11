//
//  QuestionViewHeader.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI
import GameKit

struct QuestionViewHeader: View {
  var matchID: String
  var matchStatus: GKTurnBasedMatch.Status
  var currentPlayerDisplayName: String
  var questionIndex: Int
  var questionViewState: QuestionViewState
  
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
        Text("Question \(questionNumber + 1)")
          .font(.subheadline)
          .foregroundColor(Color.pink)
        Spacer()
      }
    }
  }
}

struct QuestionViewHeader_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewHeader(matchID: "123",
                       matchStatus: .open,
                       currentPlayerDisplayName: "Markim",
                       questionIndex: 1,
                       questionViewState: .playing)
      .previewLayout(.sizeThatFits)
  }
}
