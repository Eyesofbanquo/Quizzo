//
//  MLPlayer.swift
//  ocky
//
//  Created by Markim Shaw on 11/6/21.
//

import Foundation

enum MLPlayerState: Int, Codable {
  case waiting = 0
  case creating = 1
  case playing = 2
}

class MLPlayer: Codable {
  var displayName: String
  var lives: Int
  var correctQuestions: [UUID]
  
  init(displayName: String, lives: Int, correctQuestions: [UUID]) {
    self.displayName = displayName
    self.lives = lives
    self.correctQuestions = correctQuestions
  }
  
  func addCorrectQuestion(id: UUID) {
    correctQuestions.append(id)
  }
}
