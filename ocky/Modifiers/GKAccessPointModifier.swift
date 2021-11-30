//
//  GKAccessPointModifier.swift
//  ocky
//
//  Created by Markim Shaw on 11/29/21.
//

import GameKit
import SwiftUI

struct GKAccessPointModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(.top, 62)
      .onAppear {
        GKAccessPoint.shared.location = .topLeading
        GKAccessPoint.shared.isActive = true
      }
      .onDisappear(perform: {
        GKAccessPoint.shared.isActive = false
      })
  }
}
