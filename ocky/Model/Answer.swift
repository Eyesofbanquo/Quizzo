//
//  Answer.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import Foundation

struct Answer: Codable, Identifiable {
  var id: UUID
  var isCorrect: Bool
  var text: String
  
  init(isCorrect: Bool, text: String) {
    self.isCorrect = isCorrect
    self.text = text
    self.id = UUID()
  }
}

extension Answer {
  static var empty: Answer {
    Answer(isCorrect: false, text: "")
  }
}
