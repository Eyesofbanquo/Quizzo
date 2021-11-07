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
  case authenticate, none
}

//class MLGameStateHandler: ObservableObject {
//}

final class MLGameController: UIViewController,
                              GKLocalPlayerListener {
  
  // MARK: - Views -
  private var helloLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    return label
  }()
  
  
  lazy var currentState: MLGameState = .none
  var gameStatePassthrough = PassthroughSubject<MLGameState, Never>()
  var cancellables = Set<AnyCancellable>()
  
  // MARK: - Lifecycle -
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addMLGameView()

    gameStatePassthrough.sink { nextState in
      print("Received: \(nextState)")
      switch (nextState, self.currentState) {
        case (.authenticate, .none):
          self.authenticateUser()
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
  }
}

extension MLGameController: GKTurnBasedMatchmakerViewControllerDelegate  {
  func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
    
  }
  
  func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
    
  }
  
  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
   
  }
}

struct MLGame: UIViewControllerRepresentable {
  
  @Binding var isAuthenticated: Bool?
  
  func makeUIViewController(context: Context) -> MLGameController {
    let controller = MLGameController()
    return controller
  }
  
  func updateUIViewController(_ uiViewController: MLGameController, context: Context) {
    // to-do
  }
}

struct MLGameView: View {
  @State private var receivedAction: MLGameState = .none
  var actions: PassthroughSubject<MLGameState, Never>
  var body: some View {
    VStack {
      Text("Press button")
      Button(action: {
        let randomAction = MLGameState.allCases.randomElement() ?? .none
        actions.send(randomAction)
      }) {
        Text("Authenticate user")
      }
    }
    .onReceive(actions) { output in
      self.receivedAction = output
    }
  }
}

struct MLGameView_Previews: PreviewProvider {
  static var previews: some View {
    MLGame(isAuthenticated: .constant(false))
  }
}
