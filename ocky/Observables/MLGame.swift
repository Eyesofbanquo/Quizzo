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

class MLGame: NSObject, ObservableObject {
  @Published var gameState: MLGameState = .idle
  
  lazy private var playerManager = GKPlayerManager()
  lazy private var stateStack: MLGameStateStack = MLGameStateStack()
  
  var gameData: MLGameData
  var activeMatch: GKTurnBasedMatch?
  var gameStatePasshtrough = PassthroughSubject<MLGameState, Never>()
  
  /// This represents the current player in turn. Returned as an `MLPlayer` object
  var currentPlayer: MLPlayer? {
    guard let match = activeMatch else { return nil }
    return playerManager.currentPlayerInTurn(forMatch: match, usingGameData: gameData)
  }
  
  /// This represents the current user of the app playing the game
  var user: MLPlayer? {
    playerManager.currentMLPlayer(inGame: gameData)
  }
  
  /// This returns `true` if the current user of the app is in turn. `false` otherwise
  var isUserTurn: Bool {
    guard let match = activeMatch else { return false }
    
    return playerManager.isCurrentPlayerTurn(forMatch: match)
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
      let mlMatches = matches.filter { ($0.status == .open || $0.status == .matching) && $0.currentParticipant?.matchOutcome != .quit}.map { match in
        MLMatch(matchID: match.matchID,
                participants: match.participants.compactMap { $0.player?.displayName},
                currentParticipant: match.currentParticipant?.player?.displayName ?? "",
                creationDate: match.creationDate)
      }
      self.setState(.listMatches(matches: mlMatches))
    } catch {
      print(error)
    }
  }
  
  /* Place in grader/question service */
  func appendQuestion(question: Question) {
    self.gameData.history.append(question)
  }
  
  /* Place in grader/question service */
  func isCorrect(currentQuestion question: Question, usingAnswerChoices choices: [Answer]) -> Bool {
    let correctAnswers = Set(question.correctAnswers)
    let userAnswers = Set(choices)
    let isCorrect = correctAnswers.intersection(userAnswers).count == correctAnswers.count
    return isCorrect
  }
  
  /* Place in grader/question service */
  func isCorrect(currentQuestion question: Question, usingAnswerChoices choices: [UUID]) -> Bool {
    let correctAnswers = Set(question.correctAnswers.map { $0.id })
    let userAnswers = Set(choices)
    let isCorrect = correctAnswers.intersection(userAnswers).count == correctAnswers.count
    return isCorrect
  }
  
  /* Place in grader/question service */
  func grade(currentQuestion question: Question, usingAnswerChoices choices: [Answer]) {
    if isCorrect(currentQuestion: question, usingAnswerChoices: choices) {
      let player = gameData.players.first(where: { $0.displayName == GKLocalPlayer.local.displayName })
      player?.addCorrectQuestion(id: question.id)
    }
  }
  
  @MainActor
  func loadMatch(matchID: String) async throws {
    do {
      // has the chance overriding data if first game and resumed from loadmatches state
      let match = try await GKTurnBasedMatch.load(withID: matchID)
      self.setActiveMatch(match)
      
      let isCurrentPlayer = playerManager.isCurrentPlayerTurn(forMatch: match)
      self.setState(.inQuestion(playState: .showQuestion(gameData: gameData,
                                                         isCurrentPlayer: isCurrentPlayer)))
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func sendData() async throws {
    do {
      guard let data = gameData.encode(),
      let match = activeMatch
      else { return }
      // check to make srue the person didnt quit with participant.matchoutcome
      let otherParticipants = playerManager.participants(inMatch: match, excludingCurrentPlayer: true)
      let availableParticipants = otherParticipants.all(excluding: [.quit, .timeExpired, .lost])
      try await match.endTurn(withNextParticipants: availableParticipants,
                              turnTimeout: GKTurnTimeoutDefault,
                              match: data)
      self.setActiveMatch(match)
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
      if isCurrentTurn {
        // filter out the user info
        try await match.participantQuitInTurn(with: .quit,
                                              nextParticipants: availableParticipants,
                                              turnTimeout: GKTurnTimeoutDefault,
                                              match: data)
      } else {
        try await match.participantQuitOutOfTurn(with: .quit)
      }
    } catch {
      print(error.localizedDescription)
      print("failed to quit")
      match.currentParticipant?.matchOutcome = .quit
      match.endMatchInTurn(withMatch: activeMatch?.matchData ?? Data()) { _ in }
    }
    
    self.setState(.idle)
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
  
  @MainActor
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
