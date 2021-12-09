//
//  Answer.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import Foundation

struct Answer: Codable, Identifiable, Hashable {
  var id: UUID
  var isCorrect: Bool
  var text: String
  
  init(isCorrect: Bool, text: String) {
    self.isCorrect = isCorrect
    self.text = text
    self.id = UUID()
  }
  
  init(fromResponse response: AnswerResponse) {
    self.id = UUID(uuidString: response.id) ?? UUID()
    self.text = response.text
    self.isCorrect = response.isCorrect
  }
}

extension Answer {
  static var empty: Answer {
    Answer(isCorrect: false, text: "")
  }
}
