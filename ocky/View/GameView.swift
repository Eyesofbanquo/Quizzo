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
  @EnvironmentObject var handler: MLGame
  var userIsCurrentParticipant: Bool {
    GKLocalPlayer.local.displayName == currentParticipant
  }
  var currentParticipant: String {
    handler.activeMatch?.currentParticipant?.player?.displayName ?? ""
  }
  var body: some View {
    Group {
      switch handler.gameState {
        case .idle:
          VStack {
            Button(action: {
              handler.setState(.findMatch)
            }) {
              Text("Find match")
            }
            Button(action: {
              handler.setState(.loadMatches)
            }) {
              Text("Load matches")
            }
          }
          .transition(.move(edge: .trailing))
        case .listMatches(let mlMatches):
          MatchListView(matches: mlMatches)
            .environmentObject(handler)
            .transition(.move(edge: .trailing))
        case .playing:
          Group {
            if handler.gameData.history.isEmpty {
              QuestionView(questionNumber: 0, question: nil)
            }
            
            if let mostRecentQuestion = handler.gameData.history.last {
              QuestionView(questionNumber: handler.gameData.history.count, question: mostRecentQuestion)
            }
          }
        case .showSelectedMatch(let gameData, let currentParticipant):
          QuestionView(questionNumber: gameData.history.count, question: gameData.history.last, state: currentParticipant ? .playing : .results)
        case .loadMatches, .loadMatch, .findMatch:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        @unknown default:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
      }
    }
  }
  
  
  private func PlayingView() {
    
  }
  
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
      .environmentObject(MLGame.stub)
  }
}

