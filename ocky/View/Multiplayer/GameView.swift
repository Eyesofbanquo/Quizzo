//
//  GameView.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import SwiftUI
import Combine
import GameKit

// the active player can only be in the playing state when they go into a match
// if there isn't any history then put it into editing mode
// if you go into a match and aren't active player then make it showing

struct GameView: View {
  // MARK: - State: Env -
  @EnvironmentObject var handler: MLGame
  
  // MARK: - State: Local -
  @State private var presentSettingsView: Bool = false

  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      VStack {
        Group {
          switch handler.gameState {
            case .idle:
              MultiplayerMainView()
                .environmentObject(handler)
            case .listMatches(let mlMatches):
              MatchListView(matches: mlMatches)
                .environmentObject(handler)
            case .inQuestion(let playState):
              QuestionViewCoordinator(questionViewState: playState)
                .environmentObject(handler)
            case .result(question: let question, answers: let answers):
              QuestionResultView(question: question, selectedAnswers: answers)
                .environmentObject(handler)
            case .winLoss(won: let won):
              WinLossView(won: won)
                .environmentObject(handler)
            case .loadMatches, .loadMatch, .findMatch:
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Theme.Light))
                .scaleEffect(2.0)
          }
        }
      }
      .sheet(isPresented: $presentSettingsView) {
        VStack {
          Text("Hi")
        }
      }
    }
  }
  
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
      .environmentObject(MLGame.stub)
  }
}

