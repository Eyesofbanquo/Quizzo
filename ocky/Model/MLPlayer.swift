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

struct MLPlayer: Codable {
  var displayName: String
}
