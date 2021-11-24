//
//  GameData.swift
//  ocky
//
//  Created by Markim Shaw on 11/6/21.
//

import Foundation

struct MLGameData: Codable {
  
  var players: [MLPlayer] = []
  var history: [Question] = []
  
  func isCorrect(question: Question, forPlayer player: MLPlayer) -> Bool {
    player.correctQuestions.contains(where: { $0.uuidString == question.id.uuidString })
  }
}

extension MLGameData {
  func encode() -> Data? {
    return try? JSONEncoder().encode(self)
  }
  
  static func decode(data: Data) -> MLGameData? {
    return try? JSONDecoder().decode(MLGameData.self, from: data)
  }
}
