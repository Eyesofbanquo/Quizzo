//
//  OckyStateManager.swift
//  ocky
//
//  Created by Markim Shaw on 12/5/21.
//

import Foundation

class OckyStateManager: ObservableObject {
  @Published var currentState: OckyState
  
  init() {
    currentState = .menu
  }
  
  func send(_ state: OckyState) {
    currentState = state
  }
}
