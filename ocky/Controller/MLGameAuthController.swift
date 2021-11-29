//
//  MLGameController.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/6/21.
//

import Foundation
import GameKit
import SwiftUI
import Combine

final class MLGameAuthController: UIViewController {
  
  // MARK: - State -
  var gameStarted: Binding<Bool>
  var gameStatePassthrough = CurrentValueSubject<MLGameAuthState, Never>(.none)
  var cancellables = Set<AnyCancellable>()
  
  // MARK: - Services -
  var authService: AuthService
  
  // MARK: - Init -
  
  init(gameStarted: Binding<Bool>,
       authService: AuthService = GameCenterAuthService()) {
    self.gameStarted = gameStarted
    self.authService = authService
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addMLGameView()

    gameStatePassthrough.sink { nextState in
      print("Received: \(nextState)")
      switch nextState {
        case .isAuthenticating:
          Task {
            await self.authenticateUser()
          }
        default: break
      }
    }
    .store(in: &cancellables)
  }
  
  /// Use Autolayout to add the `MLGameAuthView`.
  private func addMLGameView() {
    let hostingvc = UIHostingController(rootView: MLGameAuthView(authenticated: gameStarted,
                                                                 actions: gameStatePassthrough))
    hostingvc.view.translatesAutoresizingMaskIntoConstraints = false
    addChild(hostingvc)
    view.addSubview(hostingvc.view)
    NSLayoutConstraint.activate([
      hostingvc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingvc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingvc.view.topAnchor.constraint(equalTo: view.topAnchor),
      hostingvc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    hostingvc.didMove(toParent: self)
  }
  
  @MainActor
  private func authenticateUser() async {
    let authStatus = await authService.authenticate()
    
    if case .isAuthenticated = authStatus {
      self.launchGame()
    }
    
    if case .needsAuthentication(let controller) = authStatus,
       let gameCenterController = controller {
      self.present(gameCenterController, animated: true)
    }
  }
  
  /// Changes `authenticated` status from `Entrypoint` from **False** to **True** which will present the `GameView`.
  private func launchGame() {
    self.gameStarted.wrappedValue = true
  }
}
