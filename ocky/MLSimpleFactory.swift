//
//  MLSimpleFactory.swift
//  ocky
//
//  Created by Markim Shaw on 11/16/21.
//

import Foundation
import GameKit

protocol Matchable {
  var id: String { get }
  var currentParticipant: String { get }
  var creationDate: Date { get }
}

protocol MLFactoryProtocol {
  associatedtype M = Matchable
  func createMatches(fromTurnBasedMatches matches: [GKTurnBasedMatch], excludingStatus statuses: [GKTurnBasedMatch.Status], excludingOutcomes outcomes: [GKTurnBasedMatch.Outcome]) -> [M]
}

class MLSimpleFactory: MLFactoryProtocol {
  typealias Matchable = MLMatch
  func createMatches(fromTurnBasedMatches matches: [GKTurnBasedMatch],
                     excludingStatus statuses: [GKTurnBasedMatch.Status] = [],
                     excludingOutcomes outcomes: [GKTurnBasedMatch.Outcome] = []) -> [Matchable] {
    return matches.filter { match in
      if let currentParticipant = match.currentParticipant {
        return !statuses.contains(match.status) && !outcomes.contains(currentParticipant.matchOutcome)
      } else {
        return !statuses.contains(match.status)
      }
    }.map { match in
      MLMatch(matchID: match.matchID,
              participants: match.participants.compactMap { $0.player?.displayName},
              currentParticipant: match.currentParticipant?.player?.displayName ?? "",
              creationDate: match.creationDate)
    }
  }
}
