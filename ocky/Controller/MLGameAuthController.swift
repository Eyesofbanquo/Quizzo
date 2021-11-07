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

enum MLGameAuthState: CaseIterable {
  case isAuthenticating, isAuthenticated, none
}

final class MLGameAuthController: UIViewController,
                              GKLocalPlayerListener {
  
  // MARK: - State -
  var gameStarted: Binding<Bool>
  var match: Binding<GKTurnBasedMatch?>
  var gameStatePassthrough = CurrentValueSubject<MLGameAuthState, Never>(.none)
  var cancellables = Set<AnyCancellable>()
  
  // MARK: - Init -
  
  init(gameStarted: Binding<Bool>,
       match: Binding<GKTurnBasedMatch?>) {
    self.gameStarted = gameStarted
    self.match = match
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
          self.authenticateUser()
        default: break
      }
    }
    .store(in: &cancellables)
  }
  
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
  
  private func authenticateUser() {
    GKLocalPlayer.local.authenticateHandler = { viewController, error in
      if GKLocalPlayer.local.isAuthenticated {
        self.gameStatePassthrough.send(.isAuthenticated)
      } else if let vc = viewController {
        self.present(vc, animated: true)
      }
    }
  }
  
  private func presentMatchmaker() {
    self.gameStarted.wrappedValue = true
  }
}

extension MLGameAuthController: GKTurnBasedMatchmakerViewControllerDelegate  {
  func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
    self.dismiss(animated: true, completion: {
      self.gameStatePassthrough.send(.isAuthenticated)
    })
  }
  
  func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
    print(error)
  }
  
  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
    self.match.wrappedValue = match
    self.dismiss(animated: true, completion: nil)
   print("haha")
  }
  
  func player(_ player: GKPlayer, receivedExchangeCancellation exchange: GKTurnBasedExchange, for match: GKTurnBasedMatch) {
    print("called?")
  }
}
