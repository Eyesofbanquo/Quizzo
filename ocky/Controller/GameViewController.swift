//
//  GameTestView.swift
//  ocky
//
//  Created by Markim Shaw on 11/6/21.
//

import SwiftUI
import Combine
import GameKit

class GameViewController: UIViewController {
  
  // MARK: - Properties -
  
  var handler: MLGame = MLGame()
  var cancellables = Set<AnyCancellable>()
  
  // MARK: - Initializers -
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
  
  // MARK: - Lifecycle -
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
    request.recipients
    request.minPlayers = 2
    request.maxPlayers = 2
    request.inviteMessage = "Get in here ASAP"
    
    let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
    vc.turnBasedMatchmakerDelegate = self
    vc.matchmakingMode = .automatchOnly
    self.present(vc, animated: true)
  }
}

extension GameViewController: GKLocalPlayerListener {
  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
    if self.presentedViewController is GKTurnBasedMatchmakerViewController {
      self.dismiss(animated: true, completion: nil)
    }
    
    print(match.currentParticipant?.player?.displayName ?? "", match.currentParticipant?.status)
    
    if let matchData = match.matchData,
              let gameData = MLGameData.decode(data: matchData),
              gameData.history.count == 1 {
      let player = MLPlayer(displayName: GKLocalPlayer.local.displayName,
                            lives: 3,
                            correctQuestions: [])
      var newGameData = MLGameData()
      newGameData.players.append(contentsOf: gameData.players)
      newGameData.players.append(player)
      newGameData.history.append(contentsOf: gameData.history)
      self.handler.setActiveMatch(match, andGameData: newGameData)
    } else if let matchData = match.matchData,
              let gameData = MLGameData.decode(data: matchData),
              gameData.history.count > 1 {
      self.handler.setActiveMatch(match)
    } else {
      let player = MLPlayer(displayName: GKLocalPlayer.local.displayName, lives: 3, correctQuestions: [])
      let gameData = MLGameData(players: [player], history: [])
      self.handler.setActiveMatch(match, andGameData: gameData)
    }
////    self.handler.activeMatch = match
//    self.handler.setActiveMatch(match)
    self.handler.setState(.playing)
    print("haha")
  }

  func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
    print("is this called?")
  }
  
  func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
    print("or is this called?")
  }
  
  func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
    match.currentParticipant?.matchOutcome = .quit
    match.endMatchInTurn(withMatch: match.matchData ?? Data()) { _ in }
  }
  
  func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
    print("match ended")
  }
  
  func player(_ player: GKPlayer, didAccept invite: GKInvite) {
    
  } 
}


extension GameViewController: GKTurnBasedMatchmakerViewControllerDelegate {
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
  
}