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
        case .findMatch:
          Button(action: {
            handler.setState(.findMatch)
          }) {
            Text("Find match")
          }
        case .loadMatches, .loadMatch:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        case .displayMatches(let mlMatches):
          ZStack {
            VStack {
              HStack {
                Button(action: {
                  handler.setState(.idle)
                }) {
                  Image(systemName: "xmark.circle.fill")
                    .padding()
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
              }
              LazyVStack {
                ForEach(mlMatches, id: \.matchID) { match in
                  MatchView(match: match)
                    .zIndex(2.0)
                    .onTapGesture {
                      self.handler.setState(.loadMatch(matchID: match.matchID))
                    }
                }
              }
              .zIndex(2.0)
              Spacer()
            }
            .zIndex(2.0)
          }
          .transition(.move(edge: .trailing))
        case .playing(let match):
          VStack {
            Text("Welcome, \(GKLocalPlayer.local.displayName)")
            Text("Number of players: \(handler.activeMatch?.participants.count ?? 1)")
            Text("We're waiting on... \(currentParticipant)")
            
            if userIsCurrentParticipant {
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
  
  
  private func PlayingView() {
    
  }
  
}

struct GameView_Previews: PreviewProvider {
  static var previews: some View {
    GameView()
      .environmentObject(MLGame.stub)
  }
}
