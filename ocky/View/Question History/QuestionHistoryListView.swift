//
//  QuestionHistoryListView.swift
//  ocky
//
//  Created by Markim Shaw on 11/23/21.
//

import SwiftUI

struct QuestionHistoryListView: View {
  // MARK: - State: Environment -
  @EnvironmentObject var handler: MLGame
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack {
          ForEach(handler.gameData.history.reversed()) { question in
            QuestionHistorySnippet(player: question.player,
                                   question: question,
                                   isCorrect: isCorrect(forQuestion: question, givenPlayer: question.player),
                                   isCurrentQuestion: question.id.uuidString == handler.gameData.history.last?.id.uuidString)
          }
        }
      }
      .navigationTitle(Text("Game History"))
    }
  }
  
  private func isCorrect(forQuestion question: Question, givenPlayer player: String) -> Bool {
    guard let foundPlayer = handler.gameData.players.first(where: {$0.displayName == player}) else { return false }
    return handler.gameData.isCorrect(question: question, forPlayer: foundPlayer)
  }
}

struct QuestionHistoryListView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionHistoryListView()
      .environmentObject(MLGame())
  }
}
