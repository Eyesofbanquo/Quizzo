//
//  MLGameAuthViewRepresentable.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import Foundation
import SwiftUI
import GameKit

struct MLGameAuthViewRepresentable: UIViewControllerRepresentable {
  
  @Binding var authenticated: Bool
  @Binding var match: GKTurnBasedMatch?
  
  func makeUIViewController(context: Context) -> MLGameAuthController {
    let controller = MLGameAuthController(gameStarted: $authenticated,
                                          match: $match)
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: MLGameAuthController, context: Context) {
    // to-do
  }
}
