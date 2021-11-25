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
  
  func isCurrent(question: Question) -> Bool {
    question.id.uuidString == handler.gameData.history.last?.id.uuidString
  }
  
  func idx(forQuestion question: Question) -> Int {
    handler.gameData.history.firstIndex(where: { $0.id.uuidString == question.id.uuidString }) ?? 0
  }
  
  func playedBy(question: Question) -> String {
    handler.gameData.players.first(where: { $0.displayName != question.player })?.displayName ?? "unknonw"
  }
  
  func correctAnswerUUID(question: Question) -> [UUID] {
    let otherPlayer = handler.gameData.players.first(where: { $0.displayName != question.player })
    
    if let playerChoices = otherPlayer?.correctQuestions {
      let setOfPlayerChoices = Set(playerChoices)
      let setOfCorrectChoices = Set(question.correctAnswers.map { $0.id })
      
      let intersection = setOfPlayerChoices.intersection(setOfCorrectChoices)
      return Array(intersection)
    }
    return []
  }
  
  func correctAnswer(question: Question) -> Bool {
    guard let otherPlayer = handler.gameData.players.first(where: { $0.displayName != question.player }) else { return false }
    
    return otherPlayer.correctQuestions.contains(question.id)
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Theme.BG
          .ignoresSafeArea()
        ScrollView {
          LazyVStack {
            ForEach(handler.gameData.history.reversed()) { question in
              NavigationLink(destination: QuestionHistoryView(matchID: handler.activeMatch?.matchID ?? "",
                                                              questionIdx: idx(forQuestion: question), question: question, isCurrentQuestion: isCurrent(question: question), playedBy: playedBy(question: question),
                                                             correctQuestion: correctAnswer(question: question))) {
                QuestionHistorySnippet(player: question.player,
                                       question: question,
                                       isCorrect: isCorrect(forQuestion: question, givenPlayer: question.player),
                                       isCurrentQuestion: isCurrent(question: question)
                )
              }
            }
          }
        }
        .navigationTitle(Text("Game History"))
      }
      
    }.onAppear {
      UINavigationBar.appearance().largeTitleTextAttributes = [
        .foregroundColor: UIColor.white]
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
