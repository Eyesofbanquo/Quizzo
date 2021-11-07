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
}

extension MLGameData {
  func encode() -> Data? {
    return try? JSONEncoder().encode(self)
  }
  
  static func decode(data: Data) -> MLGameData? {
    return try? JSONDecoder().decode(MLGameData.self, from: data)
  }
}
