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
  lazy var gameStatePassthrough = PassthroughSubject<MLGameAuthState, Never>()
  var cancellables = Set<AnyCancellable>()
  
  // MARK: - Services -
  var authService: AuthService
  
  var state: Binding<MLGameAuthState>
  
//  @Binding var currentStateBinding: Binding<MLGameState>
  
  // MARK: - Init -
  
  init(state: Binding<MLGameAuthState>, authService: AuthService = GameCenterAuthService()) {
    self.authService = authService
    self.state = state
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addMLGameView()
    
//    self.authenticateUser()
    
    gameStatePassthrough.receive(on: DispatchQueue.main).sink { nextState in
      print("Received: \(nextState)")
      switch nextState {
        case .isAuthenticating:
          self.state.wrappedValue = .isAuthenticating
          self.authenticateUser()
        default: break
      }
    }
    .store(in: &cancellables)
    
    gameStatePassthrough.send(.isAuthenticating)
  }
  
  /// Use Autolayout to add the `MLGameAuthView`.
  private func addMLGameView() {
    let hostingvc = UIHostingController(rootView: MLGameAuthView(state: state))
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
  
  private func authenticateUser() {
    
    authService.authenticateCompletion { result in
      switch result {
        case .success(let success):
          switch success {
            case .isAuthenticated: self.launchGame()
            case .needsAuthentication(context: let controller):
              if let gameCenterController = controller {
                self.present(gameCenterController, animated: true)
              }
            default: break
          }
      }
    }
  }
  
  /// Changes `authenticated` status from `Entrypoint` from **False** to **True** which will present the `GameView`.
  private func launchGame() {
//    self.gameStarted.wrappedValue = true
//    gameStatePassthrough.send(.inGame)
    self.state.wrappedValue = .inGame
  }
}
