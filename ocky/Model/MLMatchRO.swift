//
//  MLMatchRO.swift
//  ocky
//
//  Created by Markim Shaw on 11/18/21.
//

import Foundation
import RealmSwift

class PlayerRO: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var matchID: String
  @Persisted var correctQuestionID: String?
  @Persisted var updatedLives: Int
  
  convenience init(matchID: String, correctQuestionID: String?, updatedLives: Int) {
    self.init()
    
    self.matchID = matchID
    self.correctQuestionID = correctQuestionID
    self.updatedLives = updatedLives
  }
}

