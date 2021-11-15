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

class MLGameStateStack {
  var stack: [MLGameState]
  
  init() {
    stack = []
  }
  
  func push(_ state: MLGameState) {
    if case .inQuestion = self.peek(),
       case .inQuestion = state {
      self.pop()
    }
    
    switch state {
      case .findMatch, .loadMatch, .loadMatches, .result:
        return
      default: stack.append(state)
    }
  }
  
  func pop() {
    stack = stack.dropLast()
    stack.count == 0 ? push(.idle) : ()
  }
  
  func peek() -> MLGameState? {
    stack.last
  }
}


class MLGame: NSObject, ObservableObject {
  var gameData: MLGameData
  lazy var stateStack: MLGameStateStack = MLGameStateStack()
  var activeMatch: GKTurnBasedMatch?
  @Published var gameState: MLGameState = .idle
  var gameStatePasshtrough = PassthroughSubject<MLGameState, Never>()
  
  var currentPlayer: MLPlayer? {
    guard gameData.players.count > 0 else { return nil }
    if activeMatch?.currentParticipant?.player?.displayName == GKLocalPlayer.local.displayName {
      return gameData.players.first( where: { $0.displayName == GKLocalPlayer.local.displayName} )
    } else {
      return gameData.players.first( where: { $0.displayName == activeMatch?.currentParticipant?.player?.displayName} )
    }
  }
  
  var user: MLPlayer? {
    return gameData.players.first( where: { $0.displayName == GKLocalPlayer.local.displayName} )
  }
  
  var isUserTurn: Bool {
    activeMatch?.currentParticipant?.player?.displayName == GKLocalPlayer.local.displayName
  }
  
  var isCurrentPlayer: Bool {
    return gameData.players.first( where: { $0.displayName == GKLocalPlayer.local.displayName} ) != nil
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
  
  func appendQuestion(question: Question) {
    self.gameData.history.append(question)
  }
  
  func isCorrect(currentQuestion question: Question, usingAnswerChoices choices: [Answer]) -> Bool {
    let correctAnswers = Set(question.correctAnswers)
    let userAnswers = Set(choices)
    let isCorrect = correctAnswers.intersection(userAnswers).count == correctAnswers.count
    return isCorrect
  }
  
  func isCorrect(currentQuestion question: Question, usingAnswerChoices choices: [UUID]) -> Bool {
    let correctAnswers = Set(question.correctAnswers.map { $0.id })
    let userAnswers = Set(choices)
    let isCorrect = correctAnswers.intersection(userAnswers).count == correctAnswers.count
    return isCorrect
  }
  
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
      
      self.setState(.inQuestion(playState: .showQuestion(gameData: gameData,
                                       isCurrentPlayer: match.currentParticipant?.player?.displayName == GKLocalPlayer.local.displayName)))
      
    } catch {
      print(error)
    }
  }
  
  @MainActor
  func sendData() async throws {
    do {
      guard let data = gameData.encode() else { return }
      // check to make srue the person didnt quit with participant.matchoutcome
      try await activeMatch?.endTurn(withNextParticipants: activeMatch?.participants.filter { $0.player?.displayName != user?.displayName } ?? [],
                                     turnTimeout: GKTurnTimeoutDefault,
                                     match: data)
      self.setActiveMatch(activeMatch!)
      // Take the user to a waiting state
      self.setState(.inQuestion(playState: .showQuestion(gameData: gameData, isCurrentPlayer: false)))
    } catch {
      print(error.localizedDescription)
      print("Send data failed")
    }
  }
  
  @MainActor
  func quitGame() async throws {
    guard let data = gameData.encode() else { return }
    do {
      if activeMatch?.currentParticipant?.player?.displayName == GKLocalPlayer.local.displayName {
        try await activeMatch?.participantQuitInTurn(with: .quit,
                                                     nextParticipants: activeMatch?.participants ?? [],
                                                     turnTimeout: GKTurnTimeoutDefault, match: data)
      } else {
        try await activeMatch?.participantQuitOutOfTurn(with: .quit)
      }
    } catch {
      print(error.localizedDescription)
      print("failed to quit")
      activeMatch?.currentParticipant?.matchOutcome = .quit
      activeMatch?.endMatchInTurn(withMatch: activeMatch?.matchData ?? Data()) { _ in }
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
  
  func setActiveMatch(_ match: GKTurnBasedMatch?, andGameData gameData: MLGameData? = nil) {
    if let gameData = gameData {
      // Just pass game data through cuz match is in progress
      self.gameData = gameData
    } else if let match = match,
       let matchData = match.matchData,
       let gameData = MLGameData.decode(data: matchData) {
      // Same as above. Match is in progress
      self.gameData = gameData
    }
    
    if !self.gameData.players.contains(where: { $0.displayName == GKLocalPlayer.local.displayName }) {
      self.gameData.players.append(MLPlayer(displayName: GKLocalPlayer.local.displayName,
                                            lives: 3,
                                            correctQuestions: []))
    }
    
    self.activeMatch = match
  }
  
  func clearActiveMatch() {
    self.activeMatch = nil
    self.gameData = MLGameData()
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
