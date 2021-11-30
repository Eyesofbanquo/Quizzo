//
//  MainView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI
import GameKit

struct Entrypoint: View {
  // MARK: - State -
  
  @AppStorage("signup") private var signup: Bool = false
  @AppStorage("firstLaunch") private var firstLaunch: Bool = true
  
  @State private var authenticated: Bool = false
  
  @StateObject private var feedbackGen: FeedbackGenerator = FeedbackGenerator()
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      displayAuthViewIfNeeded(!authenticated)
      
      displayGameViewIfNeeded(authenticated)
    }
  }
}

struct Entrypoint_Previews: PreviewProvider {
  static var previews: some View {
    Entrypoint()
  }
}

extension Entrypoint {
  /// Displays the `MLGameAuthViewRepresentable` view which represents
  /// the `Game Center` login process in view form
  func displayAuthViewIfNeeded(_ condition: Bool) -> some View {
    guard condition else { return AnyView(EmptyView()) }
    
    return AnyView(MLGameAuthViewRepresentable(authenticated: $authenticated)
      .environmentObject(feedbackGen))
  }
  
  func displayGameViewIfNeeded(_ condition: Bool) -> some View {
    guard condition else { return AnyView(EmptyView()) }
      return AnyView(GameViewRepresentable()
        .environmentObject(feedbackGen))
  }
}
