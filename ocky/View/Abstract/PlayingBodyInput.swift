//
//  PlayingBodyInput.swift
//  ocky
//
//  Created by Markim Shaw on 12/6/21.
//

import Foundation
import SwiftUI

/// Abstract input type for playing question views. Shared between Multiplayer and Single player
protocol PlayingBodyInput {
  associatedtype T = View
  associatedtype U = Self
  
  var question: Question? { get set }
  var playTurnAction: (Question?, [Answer]) -> Void { get set }
  
  static func generate(fromView view: T) -> U
}
