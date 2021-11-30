//
//  GameCenterAuthService.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import Foundation
import GameKit

/// Concrete class for `MLGameAuthController` that authenticates `Game Center`.
class GameCenterAuthService: AuthService {
  var authenticatedCompletion: ((Result<AuthServiceState, Never>) -> CheckedContinuation<AuthServiceState, Never>)? 
  
  func authenticateCompletion(_ completion: @escaping (Result<AuthServiceState, Never>) -> Void) {
    GKLocalPlayer.local.authenticateHandler = { viewController, error in
      if GKLocalPlayer.local.isAuthenticated {
        completion(.success(.isAuthenticated))
      } else if viewController != nil {
        completion(.success(.needsAuthentication(context: viewController)))
      } else {
        completion(.success(.unsuccessfulAuthentication))
      }
    }
  }
  
  func authenticate() async -> AuthServiceState {
    await withCheckedContinuation { continuation in
      authenticateCompletion { result in
        switch result {
          case .success(let success):
            continuation.resume(returning: success)
          default: continuation.resume(returning: .unsuccessfulAuthentication)
        }
      }
    }
  }
}
