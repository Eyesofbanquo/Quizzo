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
  @State private var state: MLGameAuthState = .none
  
  func makeUIViewController(context: Context) -> MLGameAuthController {
    let controller = MLGameAuthController(state: $state)
    
    return controller
  }
  
  func updateUIViewController(_ uiViewController: MLGameAuthController, context: Context) {
    // to-do
  }
}
