//
//  QuestionOtherUserResultsView.swift
//  ocky
//
//  Created by Markim Shaw on 11/23/21.
//

import SwiftUI

struct QuestionHistoryView: View {
  // MARK: - State -
  
  // MARK: - Inject -
  var recentQuestion: Question
  
  // MARK: - Layout -
  var body: some View {
    VStack(alignment: .leading) {
      ForEach(recentQuestion.choices) { choice in
        Text(choice.text)
          .questionButton(isHighlighted: choice.isCorrect)
      }
    }
  }
}

struct QuestionHistoryViewView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionHistoryView(recentQuestion: Question.stub)
  }
}
