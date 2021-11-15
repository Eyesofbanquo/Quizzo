//
//  GKPlayerDetailer.swift
//  ocky
//
//  Created by Markim Shaw on 11/15/21.
//

import Foundation
import GameKit

/// An object that details `GKPlayer` objects.
///
/// The responsibility of this object is to be able to give info on both players and participants
struct GKPlayerDetailer {
  
  var currentPlayer: GKLocalPlayer {
    GKLocalPlayer.local
  }
  
  var currentPlayerDisplayName: String {
    GKLocalPlayer.local.displayName
  }
  
  func players(inMatch match: GKTurnBasedMatch, excludingCurrentPlayer: Bool) -> [GKTurnBasedParticipant] {
    excludingCurrentPlayer ?
    match.participants.filter { $0.player?.displayName == currentPlayerDisplayName } :
    match.participants
  }
}
