//
//  OfflineQuestionView.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import SwiftUI

struct OfflineQuestionView: View {
  
  @EnvironmentObject var clipService: ClipService
  
  var question: Question
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      ScrollView {
        VStack(alignment: .leading) {
          QuestionStaticHeader(question: question)
            .padding()
          QuestionViewPlayingBody(input: OfflineQuestionViewPlayingBodyInput.generate(fromView: self))
        }
      }
      .padding(.top)
    }
  }
  
  func grade(withAnswers answers: [Answer]) {
    clipService.gradeQuiz(selectedAnswerChoices: answers)
  }
}

struct OfflineQuestionView_Previews: PreviewProvider {
  static var previews: some View {
    OfflineQuestionView(question: .stub)
      .environmentObject(ClipService())
  }
}
