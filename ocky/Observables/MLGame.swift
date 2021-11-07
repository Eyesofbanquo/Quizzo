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
  case playing(isMyTurn: Bool)
}


class MLGame: NSObject, ObservableObject {
  @Published var gameData: MLGameData
  @Published var activeMatch: GKTurnBasedMatch?
  @Published var matches: [GKTurnBasedMatch] = []
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
      self.matches = matches
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func sendData() async throws {
    do {
      guard let data = gameData.encode() else { return }
      try await activeMatch?.endTurn(withNextParticipants: activeMatch?.participants ?? [], turnTimeout: 60.0, match: data)
    } catch {
      print("Send data failed")
    }
    self.setState(.playing(isMyTurn: false))
  }
  
  @MainActor
  func quitGame() async throws {
    guard let data = gameData.encode() else { return }
    do {
      if activeMatch?.currentParticipant?.player?.displayName == GKLocalPlayer.local.displayName {
        try await activeMatch?.participantQuitInTurn(with: .quit, nextParticipants: activeMatch?.participants ?? [], turnTimeout: 60, match: data)
      } else {
        try await activeMatch?.participantQuitOutOfTurn(with: .quit)
      }
      self.setState(.idle)
//      self.activeMatch = nil
    } catch {
      print("failed to quit")
    }
    
  }
  
  func setState(_ state: MLGameState) {
    self.gameState = state
    self.gameStatePasshtrough.send(state)
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
