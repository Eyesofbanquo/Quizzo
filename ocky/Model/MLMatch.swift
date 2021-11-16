//
//  MLMatch.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import Foundation

/// This type exists to represent a lightweight version of `GKTurnBasedMatch` data. This is mainly used inside of `MatchListView` and `MatchView`.
struct MLMatch: Identifiable, Matchable {
  var id: String {
    matchID
  }
  var matchID: String
  var participants: [String]
  var currentParticipant: String
  var creationDate: Date
  
  init(matchID: String,
       participants: [String],
       currentParticipant: String,
       creationDate: Date) {
    self.matchID = matchID
    self.participants = participants
    self.currentParticipant = currentParticipant
    self.creationDate = creationDate
  }
}

extension MLMatch {
  static var stub: MLMatch {
    MLMatch(matchID: "123", participants: ["Markim", "Kyrinne"], currentParticipant: "Markim", creationDate: .now)
  }
}
