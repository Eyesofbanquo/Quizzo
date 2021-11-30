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
import RealmSwift

class MLGame: NSObject, ObservableObject {
  @Published var gameState: MLGameState = .idle
  
  lazy private var playerManager = GKPlayerManager()
  lazy private var stateStack: MLGameStateStack = MLGameStateStack()
  lazy private var mlSimpleFactory = MLSimpleFactory()
  
  var gameData: MLGameData
  var activeMatch: GKTurnBasedMatch?
  var gameStatePasshtrough = PassthroughSubject<MLGameState, Never>()
  
  let realm: Realm = try! Realm()
  
  /// This represents the current player in turn. Returned as an `MLPlayer` object. **This can only be used if `activeMatch` is set**
  var currentPlayer: MLPlayer? {
    guard let match = activeMatch else { return nil }
    return playerManager.currentPlayerInTurn(forMatch: match, usingGameData: gameData)
  }
  
  /// This represents the current user of the app playing the game. **This can only be used if `activeMatch` is set**
  var user: MLPlayer? {
    playerManager.currentMLPlayer(inGame: gameData)
  }
  
  /// This returns `true` if the current user of the app is in turn. `false` otherwise. **This can only be used if `activeMatch` is set**
  var isUserTurn: Bool {
    guard let match = activeMatch else { return false }
    
    return playerManager.isCurrentPlayerTurn(forMatch: match)
  }
  
  /// **This can only be used if `activeMatch` is set**
  var availableParticipants: [GKTurnBasedParticipant] {
    guard let match = activeMatch else { return [] }
    let otherParticipants = playerManager.participants(inMatch: match, excludingCurrentPlayer: true)
    
    return otherParticipants.all(excluding: [.quit, .timeExpired, .lost])
  }
  
  init(match: GKTurnBasedMatch? = nil) {
    self.gameData = MLGameData()
    self.activeMatch = match
    super.init()
  }
  
  @MainActor
  func loadMatches() async throws {
    do {
      let matches = try await GKTurnBasedMatch.loadMatches()
      let mlMatches = mlSimpleFactory.createMatches(fromTurnBasedMatches: matches, excludingStatus: [.open, .matching], excludingOutcomes: [.quit])
      self.setState(.listMatches(matches: mlMatches))
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func loadMatch(matchID: String) async throws {
    do {
      
      // has the chance overriding data if first game and resumed from loadmatches state
      let match = try await GKTurnBasedMatch.load(withID: matchID)
      
      await Task.sleep(UInt64(1_000_000_000 * 0.5))
      
      self.setActiveMatch(match)
      
      /* Actually load player, not match */
      /* load match from realm */
      let playerRO = realm.objects(PlayerRO.self).filter { $0.matchID == matchID }.first
      
      /* if it's found then that means the user should be in the editing stage */
      if playerRO != nil {
        self.setState(.inQuestion(playState: .editing))
      } else {
        /* Check to see if user has lives to play */
        
        if let user = self.user, user.lives > 0 {
          let isCurrentPlayer = playerManager.isCurrentPlayerTurn(forMatch: match)
          self.setState(.inQuestion(playState: .showQuestion(gameData: gameData,
                                                             isCurrentPlayer: isCurrentPlayer)))
        } else {
          // TODO - Send user to appropriate win/loss screen
        }
        
        
      }
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func sendData() async throws {
    /* Pull player info from realm. update MLGameData as needed using `QuestionService`. THen send data */
    do {
      guard let match = activeMatch
      else { return }
      
      /* Find the cached player state and add it to game data before send */
      let cachedPlayerState = realm.objects(PlayerRO.self).filter({ $0.matchID == match.matchID }).first
      if let gameDataPlayer = self.gameData.players.filter({ $0.displayName == user?.displayName }).first,
         cachedPlayerState != nil {
          gameDataPlayer.lives = cachedPlayerState!.updatedLives
          
          if let uuidString = cachedPlayerState!.correctQuestionID,
             let uuid = UUID(uuidString: uuidString) {
            gameDataPlayer.addCorrectQuestion(id: uuid)
          }
      }
      
      guard let data = gameData.encode() else { return }
      
      // check to make srue the person didnt quit with participant.matchoutcome
      let otherParticipants = playerManager.participants(inMatch: match, excludingCurrentPlayer: true)
      let availableParticipants = otherParticipants.all(excluding: [.quit, .timeExpired, .lost])
      try await match.endTurn(withNextParticipants: availableParticipants,
                              turnTimeout: GKTurnTimeoutDefault,
                              match: data)
      self.setActiveMatch(match)
      
      /* Delete the cached question */
      let cachedMatches = realm.objects(PlayerRO.self)
      let cachedMatch = cachedMatches.filter { $0.matchID == match.matchID }
      try realm.write {
        if let deletableMatch = cachedMatch.first {
          realm.delete(deletableMatch)
        }
      }
      
      // Take the user to a waiting state
      self.setState(.inQuestion(playState: .showQuestion(gameData: gameData, isCurrentPlayer: false)))
    } catch {
      print(error.localizedDescription)
      print("Send data failed")
    }
  }
  
  @MainActor
  func quitGame() async throws {
    guard let data = gameData.encode(),
    let match = activeMatch
    else { return }
    do {
      let isCurrentTurn = playerManager.isCurrentPlayerTurn(forMatch: match)
      let otherParticipants = playerManager.participants(inMatch: match, excludingCurrentPlayer: true)
      let availableParticipants = otherParticipants.all(excluding: [.quit, .timeExpired, .lost])
      guard availableParticipants.count > 0 else {
        match.currentParticipant?.matchOutcome = .quit
        try await match.endMatchInTurn(withMatch: data)
        self.clearActiveMatch()
        return
      }
      if isCurrentTurn {
        // filter out the user info
//        match.currentParticipant?.matchOutcome = .quit
//        try await match.endMatchInTurn(withMatch: data)
        try await match.participantQuitInTurn(with: .quit,
                                              nextParticipants: availableParticipants,
                                              turnTimeout: GKTurnTimeoutDefault,
                                              match: data)
      } else {
        /* Needs to throw that you win screen */
        try await match.participantQuitOutOfTurn(with: .quit)
      }
      
      try await match.remove()
    } catch {
      print(error.localizedDescription)
      print("failed to quit")
    }
    
    self.setState(.idle)
  }
  
  @MainActor
  func endgame() async throws {
    guard let match = activeMatch,
          let data = self.gameData.encode() else { return }
    
    do {
      match.currentParticipant?.matchOutcome = .lost
      match.participants.forEach { p in
        if p.player?.displayName != match.currentParticipant?.player?.displayName {
          p.matchOutcome = .won
        }
      }
      try await match.endMatchInTurn(withMatch: data)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  @MainActor
  func setState(_ state: MLGameState) {
    withAnimation {
      self.stateStack.push(state)
      self.gameState = state
      self.gameStatePasshtrough.send(state)
    }
  }
  
  func setGameData(_ gameData: MLGameData? = nil, fromMatch match: GKTurnBasedMatch? = nil) {
    
    if let gameData = gameData {
      // Just pass game data through cuz match is in progress
      self.gameData = gameData
    } else if let match = match,
              let matchData = match.matchData,
              let gameData = MLGameData.decode(data: matchData),
              gameData.history.isEmpty == false {
      // Same as above. Match is in progress
      self.gameData = gameData
    } else {
      self.gameData = MLGameData()
    }
  }
  
  func setActiveMatch(_ match: GKTurnBasedMatch?, andGameData gameData: MLGameData? = nil) {
    setGameData(gameData, fromMatch: match)
    
    let playerExists = playerManager.playerExists(inGame: self.gameData)
    if !playerExists && match != nil {
      let newPlayer = MLPlayer(displayName: GKLocalPlayer.local.displayName,
                               lives: 3,
                               correctQuestions: [])
      playerManager.addPlayer(newPlayer, toGame: &self.gameData)
    }
    
    self.activeMatch = match
  }
  
  func clearActiveMatch() {
    setActiveMatch(nil, andGameData: nil)
    setGameData()
  }
  
  func returnToPreviousState() {
    //    self.setState(self.previousGameState)
    withAnimation {
      self.stateStack.pop()
      if let state = self.stateStack.peek() {
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
      MLPlayer(displayName: "Markim", lives: 3, correctQuestions: []),
      MLPlayer(displayName: "Forest Whitaker", lives: 3, correctQuestions: [])]
    
    return handler
  }
}
