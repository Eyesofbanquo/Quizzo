//
//  OfflineQuestionView.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import SwiftUI

struct OfflineQuestionView: View {
  
  var question: Question
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      VStack {
        Spacer()
        Text("Hello, world!")
          .padding()
        QuestionViewPlayingBody(input: OfflineQuestionViewPlayingBodyInput.generate(fromView: self))
        Spacer()
      }
    }
  }
}

struct OfflineQuestionView_Previews: PreviewProvider {
  static var previews: some View {
    OfflineQuestionView(question: .stub)
  }
}
