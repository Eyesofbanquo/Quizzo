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
      Text("No data")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environmentObject(QuizService())
  }
}
