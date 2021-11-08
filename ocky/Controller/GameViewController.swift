//
//  GameTestView.swift
//  ocky
//
//  Created by Markim Shaw on 11/6/21.
//

import SwiftUI
import Combine
import GameKit

class GameViewController: UIViewController, GKTurnBasedMatchmakerViewControllerDelegate {
  
  var handler: MLGame = MLGame()
  var cancellables = Set<AnyCancellable>()
  
  func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
    self.dismiss(animated: true, completion: nil)
    Task {
      await MainActor.run {
        self.handler.setState(.idle)
      }
    }
  }
  
  func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
  }
  
  init() {
    super.init(nibName: nil, bundle: nil)
    GKLocalPlayer.local.register(self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var matchRequest: GKMatchRequest {
    let request = GKMatchRequest()
    request.minPlayers = 2
    request.maxPlayers = 2
    request.inviteMessage = "Get in here ASAP"
    return request
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addGameTestView()
    
    handler.gameStatePasshtrough
      .receive(on: DispatchQueue.main)
      .sink { newValue in
      switch newValue {
        case .findMatch:
          self.presentMatchmaker()
//          Task {
//            let match = try await GKTurnBasedMatch.find(for: self.matchRequest)
//          }
        case .loadMatches:
          Task {
            try await self.handler.loadMatches()
          }
        case .loadMatch(let matchID):
          Task {
            try await self.handler.loadMatch(matchID: matchID)
          }
        default: break
      }
    }
    .store(in: &cancellables)
  }
  
  
  
  private func addGameTestView() {
    let hostingvc = UIHostingController(rootView: GameView()
                                          .environmentObject(handler))
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

extension GameViewController: GKLocalPlayerListener {
  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
    if self.presentedViewController is GKTurnBasedMatchmakerViewController {
      self.dismiss(animated: true, completion: nil)
    }
    self.handler.activeMatch = match
    self.handler.setState(.playing(match: match))
    print("haha")
  }

  func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
    print("is this called?")
  }
  
  func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
    print("or is this called?")
  }
  
  func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
    print("wants to quit")
  }
  
  func player(_ player: GKPlayer, didAccept invite: GKInvite) {
    
  }
}



