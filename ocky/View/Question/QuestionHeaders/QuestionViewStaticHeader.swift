//
//  QuestionViewHeader.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI
import GameKit

protocol AbstractQuestionHeader {
  init(input: NavigationBarViewInput)
  var anyBody: AnyView { get  }
}

struct QuestionViewStaticHeader: View {
  
  @Binding var questionType: QuestionType
  
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
        Group {
          Image(systemName: questionType.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
        .animation(.easeInOut(duration: 0.2), value: questionType)
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
      questionType: .constant(.multipleChoice),
      matchID: "123",
      matchStatus: .open,
      currentPlayerDisplayName: "Markim",
      questionIndex: 1,
      questionViewState: .playing)
      .previewLayout(.sizeThatFits)
  }
}
