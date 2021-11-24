//
//  Theme.swift
//  ocky
//
//  Created by Markim Shaw on 11/24/21.
//

import Foundation
import SwiftUI

enum Theme {
  static var BG: Color {
    Color(uiColor: .init(named: "bg")!)
  }
  static var DarkGreen: Color {
    Color(uiColor: .init(named: "dark-green")!)
  }
  
  static var LightGreen: Color {
    Color(uiColor: .init(named: "light-green")!)
  }
  static var DarkBlue: Color {
    Color(uiColor: .init(named: "dark-blue")!)
  }
  static var LightBlue: Color {
    Color(uiColor: .init(named: "light-blue")!)
  }
  static var Yellow: Color {
    Color(uiColor: .init(named: "yellow")!)
  }
  static var Red: Color {
    Color(uiColor: .init(named: "red")!)
  }
}
