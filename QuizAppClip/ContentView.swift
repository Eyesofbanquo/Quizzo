//
//  ContentView.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var quizService: QuizService
  var body: some View {
    if let question = quizService.question {
      OfflineQuestionView(question: question)
    } else {
      VStack(spacing: 16.0) {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle())
          .tint(Theme.Light)
          .scaleEffect(x: 1.5, y: 1.5)
        Text("Retrieving your Question Clip...")
          .font(.headline)
          .foregroundColor(Theme.Light)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(QuizService())
  }
}
