//
//  SignsUpApp.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI
import RealmSwift

@main
struct SignsUpApp: SwiftUI.App {
  @StateObject private var ockyStateManager: OckyStateManager = OckyStateManager()
  @StateObject private var feedbackGen: FeedbackGenerator = FeedbackGenerator()
  var body: some Scene {
    WindowGroup {
      Entrypoint()
        .environmentObject(ockyStateManager)
        .environmentObject(feedbackGen)
    }
  }
}
