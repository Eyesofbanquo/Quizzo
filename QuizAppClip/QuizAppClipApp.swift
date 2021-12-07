//
//  QuizAppClipApp.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import SwiftUI

@main
struct QuizAppClipApp: SwiftUI.App {
  @StateObject var clipService: ClipService = ClipService()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(clipService)
        .onContinueUserActivity(
          NSUserActivityTypeBrowsingWeb,
          perform: handleUserActivity) //1
    }
  }
  
  func handleUserActivity(_ userActivity: NSUserActivity) {
    //3
    guard
      let incomingURL = userActivity.webpageURL,
      let components = URLComponents(
        url: incomingURL,
        resolvingAgainstBaseURL: true),
      let queryItems = components.queryItems
    else {
      print("unable to extract url \(userActivity.webpageURL?.absoluteString ?? "")")
      return
    }
    
    print(queryItems.first?.value ?? "")
    
    Task {
      if let quizId = queryItems.first?.value {
        await clipService.retrieveQuiz(id: quizId)
      }
    }
  }
}

