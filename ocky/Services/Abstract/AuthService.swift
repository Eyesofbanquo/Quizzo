//
//  AuthService.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import Foundation
import UIKit

enum AuthServiceState {
  case isAuthenticated
  case isAuthenticating
  case needsAuthentication(context: UIViewController?)
  case unsuccessfulAuthentication
}

/// A protocol that is meant to be the abstract entity conformed to for authentication
protocol AuthService {
  /// This function is simply the async version of `authenticateCompletion`.
  /// - Returns: Returns an auth state.
  func authenticate() async -> AuthServiceState
  func authenticateCompletion(_ completion: @escaping  (Result<AuthServiceState, Never>) -> Void)
}
