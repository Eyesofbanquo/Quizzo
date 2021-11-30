//
//  QuestionResultView.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionResultView: View {
  @EnvironmentObject var handler: MLGame
  
  @EnvironmentObject var questionService: QuestionService
  
  var question: Question
  var selectedAnswers: [Answer]
  
  var isCorrect: Bool {
    questionService.isCorrect(currentQuestion: question, usingAnswerChoices: selectedAnswers)
  }
  
  var resultText: String {
    if isCorrect {
      return "You got it right!"
    } else {
      return "Incorrect"
    }
  }
  
  var resultImage: Image {
    if isCorrect {
      return Image(systemName: "checkmark.circle.fill")
    } else {
      return Image(systemName: "xmark.circle.fill")
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Theme.BG.ignoresSafeArea()
        VStack {
          Spacer()
          resultImage
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(0.80)
            .foregroundColor(isCorrect ? Theme.LightGreen : .pink)
          Text(resultText)
            .font(.largeTitle)
            .foregroundColor(Theme.Light)
          NavigationLink(destination: LivesView(correctQuestion: isCorrect)) {
            Text("Continue")
              .questionButton(isHighlighted: false, defaultBackgroundColor: Theme.Yellow)
          }
          .navigationTitle(Text("Results"))
          Spacer()
        }
      }
      
    }.onAppear {
      UINavigationBar.appearance().largeTitleTextAttributes = [
        .foregroundColor: UIColor.white]
    }
  }
}

struct QuestionResultView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionResultView(question: .stub, selectedAnswers: [])
      .environmentObject(MLGame())
  }
}
