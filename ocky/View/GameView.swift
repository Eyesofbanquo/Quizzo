//
//  GameView.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import SwiftUI
import Combine
import GameKit

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
              handler.gameStatePasshtrough.send(.findMatch)
            }) {
              Text("Find match")
            }
            Button(action: {
              handler.gameStatePasshtrough.send(.loadMatches)
            }) {
              Text("Load matches")
            }
          }
        case .findMatch:
          Button(action: {
            handler.setState(.findMatch)
          }) {
            Text("Find match")
          }
        case .loadMatches:
          VStack {
            Text("Searching for matches started")
            if handler.matches.count > 0 {
              Text("Found \(handler.matches.count) matches!")
            }
          }
        case .playing(let isMyTurn):
          VStack {
            Text("Welcome, \(GKLocalPlayer.local.displayName)")
            Text("Number of players: \(handler.activeMatch?.participants.count ?? 1)")
            Text("We're waiting on... \(currentParticipant)")
            
            if isMyTurn {
              Button(action: {
                Task {
                  try await handler.sendData()
                }
              }) {
                Text("Play your turn")
              }
            }
            Button(action: {
              handler.setState(.findMatch)
            }) {
              Text("Go back to match list")
            }
            
            Button(action: {
              Task {
                try await handler.quitGame()
              }
            }) {
              Text("Quit game")
            }
          }
        @unknown default:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
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
