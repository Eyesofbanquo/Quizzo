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
  var questionService: QuestionService = QuestionService()
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
            self.handler.clearActiveMatch()
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
                                          .environmentObject(handler)
                                          .environmentObject(questionService))
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
    vc.matchmakingMode = .automatchOnly
    self.present(vc, animated: true)
  }
}

extension GameViewController: GKLocalPlayerListener {
  func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
    if self.presentedViewController is GKTurnBasedMatchmakerViewController {
      self.dismiss(animated: true, completion: nil)
    }
    
    //    match.currentParticipant?.matchOutcome = .lost
    //    match.endMatchInTurn(withMatch: <#T##Data#>, completionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    
    ////    self.handler.activeMatch = match
    //    self.handler.setActiveMatch(match)
    
    self.handler.setActiveMatch(match)
    
    let isAlreadyInForeground = didBecomeActive == false
    let questionHasBeenPlayed = handler.gameData.history.last != nil
    if questionHasBeenPlayed, isAlreadyInForeground {
      let playerName = handler.gameData.history.last?.player ?? "It's your turn"
      let alert = createAlert(playerName: playerName, matchID: match.matchID)
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    self.handler.setState(.inQuestion(playState: .playing))
    
    print("haha")
  }
  
  func createAlert(playerName: String, matchID: String) -> UIAlertController {
    let controller = UIAlertController(title: "\(playerName) just played their turn", message: "Would you like to play yours?", preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] _ in
      handler.setState(.loadMatch(matchID: matchID))
    }))
    controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in }))
    return controller
  }
  
  func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
    print("is this called?")
  }
  
  func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
    print("or is this called?")
  }
  
  func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
    match.currentParticipant?.matchOutcome = .quit
    let availableParticipants = handler.availableParticipants
    match.participantQuitInTurn(with: .quit,
                                nextParticipants: availableParticipants,
                                turnTimeout: GKTurnTimeoutDefault,
                                match: match.matchData ?? Data(),
                                completionHandler: nil)
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
