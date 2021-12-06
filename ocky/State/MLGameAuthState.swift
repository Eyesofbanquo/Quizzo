//
//  MLGameAuthState.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import Foundation

/// The current state of the `MLGameAuthView`.
enum MLGameAuthState: CaseIterable {
  case isAuthenticating, isAuthenticated, none /*quizMode*/
  case inGame
}
