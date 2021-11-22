//
//  MLGameStateStack.swift
//  ocky
//
//  Created by Markim Shaw on 11/15/21.
//

import Foundation

/// A class that manages a LIFO stack of `MLGameState` objects
class MLGameStateStack {
  private(set) var stack: [MLGameState]
  
  init() {
    stack = []
  }
  
  /// Push a new `MLGameState` object on top of the LIFO stack. This function also maintains
  /// the flow of the `MLGame`.
  /// This object **will not** push `.inQuestion` objects on top of each other. It will simply replace those.
  /// This object also does not push the following states: `.findMatch`, `.loadMatch`, `.loadMatches`, `.result`.
  /// - Parameter state: The `MLGameState` object to push.
  func push(_ state: MLGameState) {
    if case .inQuestion = self.peek(),
       case .inQuestion = state {
      self.pop()
    }
    
    switch state {
      case .findMatch, .loadMatch, .loadMatches, .result, .winLoss:
        return
      case .idle:
        stack = [.idle]
      default: stack.append(state)
    }
  }
  
  /// Removes the most recent `MLGameState` from the stack. It will auto push `.idle` onto the stack if there are
  /// no other items in the stack. This guarantees that the stack *always has at least one* state in the stack.
  func pop() {
    stack = stack.dropLast()
    stack.count == 0 ? push(.idle) : ()
  }
  
  /// Returns the last object in the stack.
  func peek() -> MLGameState? {
    stack.last
  }
}
