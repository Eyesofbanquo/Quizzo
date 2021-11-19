//
//  MLMatchRO.swift
//  ocky
//
//  Created by Markim Shaw on 11/18/21.
//

import Foundation
import RealmSwift

class MLMatchRO: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var matchID: String
  @Persisted var resumable: Bool
  @Persisted var cachedQuestion: QuestionRO?
  
  init(matchID: String, resumable: Bool) {
    super.init()
    self.matchID = matchID
    self.resumable = resumable
  }
}

class QuestionRO: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: String
  @Persisted var name: String
  @Persisted var choices: RealmSwift.List<AnswerRO> = RealmSwift.List<AnswerRO>()
  @Persisted var player: String
  
  init(fromQuestion question: Question) {
    super.init()
    self.id = question.id.uuidString
    self.name = question.name
    self.player = question.player
    self.choices.append(objectsIn: question.choices.map { AnswerRO(fromAnswer: $0) })
  }
}

class AnswerRO: Object, ObjectKeyIdentifiable {
  @Persisted(primaryKey: true) var id: String
  @Persisted var isCorrect: Bool
  @Persisted var text: String
  
  init(fromAnswer answer: Answer) {
    super.init()
    self.id = answer.id.uuidString
    self.isCorrect = answer.isCorrect
    self.text = answer.text
  }
  
}
