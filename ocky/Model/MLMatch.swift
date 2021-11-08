//
//  MLMatch.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import Foundation

struct MLMatch: Identifiable {
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
