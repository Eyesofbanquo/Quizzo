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

enum MLGameState: CaseIterable {
  case isAuthenticating, isAuthenticated, none, matchRequest
}

final class MLGameController: UIViewController,
                              GKLocalPlayerListener {
  
  // MARK: - State -
  var gameStarted: Binding<Bool>
  var gameStatePassthrough = CurrentValueSubject<MLGameState, Never>(.none)
  var cancellables = Set<AnyCancellable>()
  
  // MARK: - Init -
  
  init(gameStarted: Binding<Bool>) {
    self.gameStarted = gameStarted
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
        case .matchRequest:
          self.presentMatchmaker()
        default: break
      }
    }
    .store(in: &cancellables)
  }
  
  private func addMLGameView() {
    let hostingvc = UIHostingController(rootView: MLGameView(actions: gameStatePassthrough))
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
        GKLocalPlayer.local.register(self)
        self.gameStatePassthrough.send(.isAuthenticated)
      } else if let vc = viewController {
        self.present(vc, animated: true)
      }
    }
  }
  
  private func presentMatchmaker() {
    guard GKLocalPlayer.local.isAuthenticated else { return }
    let request = GKMatchRequest()
    request.minPlayers = 2
    request.maxPlayers = 2
    request.inviteMessage = "Get in here ASAP"
    
    let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
    vc.turnBasedMatchmakerDelegate = self
    self.present(vc, animated: true)
  }
}

extension MLGameController: GKTurnBasedMatchmakerViewControllerDelegate  {
  func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
    self.dismiss(animated: true, completion: {
      self.gameStatePassthrough.send(.isAuthenticated)
    })
  }
  
  func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
    
  }
  
  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
   print("haha")
  }
  
  func player(_ player: GKPlayer, receivedExchangeCancellation exchange: GKTurnBasedExchange, for match: GKTurnBasedMatch) {
    print("called?")
  }
}

struct MLGame: UIViewControllerRepresentable {
  
  @Binding var gameStarted: Bool
  
  func makeUIViewController(context: Context) -> MLGameController {
    let controller = MLGameController(gameStarted: $gameStarted)
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: MLGameController, context: Context) {
    // to-do
  }
}

struct MLGameView: View {
  @State private var receivedAction: MLGameState = .none
  var actions: CurrentValueSubject<MLGameState, Never>
  
  var body: some View {
    Group {
      switch receivedAction {
        case .none:
          VStack {
            Text("Press button")
            Button(action: {
              actions.send(.isAuthenticating)
            }) {
              Text("Authenticate user")
            }
          }
        case .isAuthenticating:
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
        case .isAuthenticated:
          Button(action: {
            actions.send(.matchRequest)
          }) {
            Text("Request match")
          }
        case .matchRequest:
          Text("Match requested")
      }
    }
    .onReceive(actions) { output in
      self.receivedAction = output
      print("Received from SwiftUI")
    }
  }
}

struct MLGameView_Previews: PreviewProvider {
  static var previews: some View {
    MLGame(gameStarted: .constant(false))
  }
}
