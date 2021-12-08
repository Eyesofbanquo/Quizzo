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
  @StateObject private var clipService: ClipService = ClipService()
  
  var body: some Scene {
    WindowGroup {
      Entrypoint()
        .environmentObject(ockyStateManager)
        .environmentObject(feedbackGen)
        .onContinueUserActivity(
          NSUserActivityTypeBrowsingWeb,
          perform: handleUserActivity)
    }
  }
  
  func handleUserActivity(_ userActivity: NSUserActivity) {
    //3
    guard
      let incomingURL = userActivity.webpageURL,
      let components = URLComponents(
        url: incomingURL,
        resolvingAgainstBaseURL: true)
    else {
      print("unable to extract url \(userActivity.webpageURL?.absoluteString ?? "")")
      return
    }
    
    guard let queryItems = components.queryItems else {
      print("blah")
      return
    }
    
    print(queryItems.first?.value ?? "")
    
    if let quizId = queryItems.first?.value {
      ockyStateManager.send(.clip(id: quizId))
    }
  }
}
