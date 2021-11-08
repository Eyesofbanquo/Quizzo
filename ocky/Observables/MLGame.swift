//
//  MLGame.swift
//  ocky
//
//  Created by Markim Shaw on 11/6/21.
//

import Foundation
import SwiftUI
import GameKit
import Combine

enum MLGameState {
  case idle
  case findMatch
  case loadMatches
  case loadMatch(matchID: String)
  case displayMatches(matches: [MLMatch])
  case playing(match: GKTurnBasedMatch?)
}


class MLGame: NSObject, ObservableObject {
  @Published var gameData: MLGameData
  @Published var activeMatch: GKTurnBasedMatch?
  @Published var gameState: MLGameState = .idle
  var gameStatePasshtrough = PassthroughSubject<MLGameState, Never>()
  
  init(match: GKTurnBasedMatch? = nil) {
    self.gameData = MLGameData()
    self.activeMatch = match
    super.init()
  }

  @MainActor
  func loadMatches() async throws {
    do {
      let matches = try await GKTurnBasedMatch.loadMatches()
      let mlMatches = matches.filter { $0.status == .open }.map { match in
        MLMatch(matchID: match.matchID,
                participants: match.participants.compactMap { $0.player?.displayName},
                currentParticipant: match.currentParticipant?.player?.displayName ?? "",
                creationDate: match.creationDate)
      }
      self.setState(.displayMatches(matches: mlMatches))
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func loadMatch(matchID: String) async throws {
    do {
      let match = try await GKTurnBasedMatch.load(withID: matchID)
      self.activeMatch = match
      self.setState(.playing(match: activeMatch))
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func sendData() async throws {
    do {
      guard let data = gameData.encode() else { return }
      try await activeMatch?.endTurn(withNextParticipants: activeMatch?.participants ?? [],
                                     turnTimeout: 1.0,
                                     match: data)
      self.setState(.playing(match: activeMatch))
    } catch {
      print("Send data failed")
    }
    
  }
  
  @MainActor
  func quitGame() async throws {
    guard let data = gameData.encode() else { return }
    do {
      if activeMatch?.currentParticipant?.player?.displayName == GKLocalPlayer.local.displayName {
        try await activeMatch?.participantQuitInTurn(with: .quit, nextParticipants: activeMatch?.participants ?? [], turnTimeout: 6000, match: data)
      } else {
        try await activeMatch?.participantQuitOutOfTurn(with: .quit)
      }
      self.setState(.idle)
    } catch {
      print("failed to quit")
    }
    
  }
  
  func setState(_ state: MLGameState) {
    withAnimation {
      DispatchQueue.main.async {
        self.gameState = state
        self.gameStatePasshtrough.send(state)
      }
    }
  }

}

extension MLGame {
  static var stub: MLGame {
    let handler = MLGame(match: nil)
    handler.gameData.players = [
    MLPlayer(displayName: "Markim"),
    MLPlayer(displayName: "Forest Whitaker")]
    
    return handler
  }
}
