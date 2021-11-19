//
//  GKPlayerDetailer.swift
//  ocky
//
//  Created by Markim Shaw on 11/15/21.
//

import Foundation
import GameKit
import RealmSwift

/// An object that details `GKPlayer` objects.
///
/// The responsibility of this object is to be able to give info on both players and participants
class GKPlayerManager: ObservableObject {
  
  let realm = try! Realm()
  
  /// The display name of the user using this app to play the game
  var currentPlayerDisplayName: String {
    GKLocalPlayer.local.displayName
  }
  
  /// The `MLPlayer` object of the user using this app. Retrieves this object from an `MLGameData` object.
  /// - Parameter gameData: The game data object containing the `MLPlayer`
  /// - Returns: Returns `nil` if the player object has not been added to `MLGameData`.
  func currentMLPlayer(inGame gameData: MLGameData) -> MLPlayer? {
    gameData.players.first( where: { $0.displayName == currentPlayerDisplayName })
  }
  
  /// A check to see if the user is currently the active player in turn
  /// - Returns: Returns `true` if the user is currently the player in turn. Returns `false` otherwise
  func isCurrentPlayerTurn(forMatch match: GKTurnBasedMatch) -> Bool {
    currentParticipantInTurn(forMatch: match)?.player?.displayName == currentPlayerDisplayName
  }
  
  /// Returns `true` if player has been added to the current `MLGameData` object
  func playerExists(inGame gameData: MLGameData) -> Bool {
    gameData.players.contains(where: {$0.displayName == currentPlayerDisplayName})
  }
  
  /// Returns the current participant in turn
  func currentParticipantInTurn(forMatch match: GKTurnBasedMatch) -> GKTurnBasedParticipant? {
    match.currentParticipant
  }
  
  /// Returns **whoever** is the current player in turn. This could be the user or the other player
  /// - Parameters:
  ///   - match: The current match being played
  ///   - gameData: The game data associated with the match
  /// - Returns: Returns **whoever** is the current player in turn. This could be the user or the other player
  func currentPlayerInTurn(forMatch match: GKTurnBasedMatch, usingGameData gameData: MLGameData) -> MLPlayer? {
    guard gameData.players.count > 0 else { return nil }
    
    guard let currentParticipantInTurn = currentParticipantInTurn(forMatch: match) else { return nil }
    
    return retrieveMLPlayer(forParticipant: currentParticipantInTurn, inGame: gameData)
  }
  
  /// Returns the `MLPlayer` associated with the `GKTurnBasedParticpant`
  func retrieveMLPlayer(forParticipant participant: GKTurnBasedParticipant, inGame gameData: MLGameData) -> MLPlayer? {
    gameData.players.first(where: { $0.displayName == participant.player?.displayName })
  }
  
  /// Returns the `GKTurnBasedParticpant` associated with the `MLPlayer`
  func retrieveParticipant(forPlayer player: MLPlayer, inMatch match: GKTurnBasedMatch) -> GKTurnBasedParticipant? {
    match.participants.first(where: { $0.player?.displayName == player.displayName })
  }
  
  /// Returns all players associated with the `MLGameData` object.
  func players(inGame gameData: MLGameData, excludingCurrentPlayer: Bool) -> [MLPlayer] {
    excludingCurrentPlayer ?
    gameData.players.filter { $0.displayName != currentPlayerDisplayName } :
    gameData.players
  }
  
  /// Returns all participants associated with the `GKTurnBasedMatch` object.
  func participants(inMatch match: GKTurnBasedMatch, excludingCurrentPlayer: Bool) -> [GKTurnBasedParticipant] {
    excludingCurrentPlayer ?
    match.participants.filter { $0.player?.displayName != currentPlayerDisplayName } :
    match.participants
  }
  
  /// Returns the outcome for the `GKTurnBasedParticipant`
  func outcome(forParticipant participant: GKTurnBasedParticipant) -> GKTurnBasedMatch.Outcome {
    participant.matchOutcome
  }
  
  /// Returns the status for the `GKTurnBasedParticipant`
  func status(forParticpant participant: GKTurnBasedParticipant) -> GKTurnBasedParticipant.Status {
    participant.status
  }
  
  /// Sets  the outcome for the `GKTurnBasedParticipant`
  func set(outcome: GKTurnBasedMatch.Outcome, forParticipant participant: GKTurnBasedParticipant) {
    participant.matchOutcome = outcome
  }
  
  func addPlayer(_ player: MLPlayer, toGame gameData: inout MLGameData) {
    gameData.players.append(player)
  }
  
  func lives(inGameData gameData: MLGameData, forMatch match: GKTurnBasedMatch?) -> Int {
    guard let match = match else { return 0 }
    let noGameExistsInDatabase = realm.objects(PlayerRO.self).filter( { $0.matchID == match.matchID }).isEmpty
    
    if noGameExistsInDatabase {
      return currentMLPlayer(inGame: gameData)?.lives ?? 0
    } else {
      let playerRO = realm.objects(PlayerRO.self).filter( { $0.matchID == match.matchID }).first
      return playerRO?.updatedLives ?? 0
    }
  }
}

extension Array where Element == GKTurnBasedParticipant {
  func all(_ status: GKTurnBasedParticipant.Status) -> Bool {
    let allSupportCondition = self.filter { $0.status == status }
    return allSupportCondition.count == self.count
  }
  
  func all(_ outcome: GKTurnBasedMatch.Outcome) -> Bool {
    let allSupportCondition = self.filter { $0.matchOutcome == outcome }
    return allSupportCondition.count == self.count
  }
  
  func all(excluding outcome: [GKTurnBasedMatch.Outcome]) -> [GKTurnBasedParticipant] {
    self.filter { outcome.contains($0.matchOutcome) == false }
  }
}
