//
//  GameTestViewRepresentable.swift
//  ocky
//
//  Created by Markim Shaw on 11/7/21.
//

import Foundation
import GameKit
import SwiftUI

struct GameViewRepresentable: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> GameViewController {
    let controller = GameViewController()
    return controller
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    
  }
}
