//
//  OckyState.swift
//  ocky
//
//  Created by Markim Shaw on 12/5/21.
//

import Foundation

/// This determines the entire state of the app
enum OckyState {
  case single
  case creator
  case multiplayer
  case menu
  case clip(id: String)
}
