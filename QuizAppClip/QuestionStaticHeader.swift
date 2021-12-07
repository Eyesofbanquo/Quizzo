//
//  QuestionStaticHeader.swift
//  QuizAppClip
//
//  Created by Markim Shaw on 12/6/21.
//

import SwiftUI

struct QuestionStaticHeader: View {
  var question: Question
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Question Clip")
          .font(.title)
          .bold()
        Spacer()
      }
      
      Text("\(question.name.capitalized) ?")
        .font(.headline)
        .foregroundColor(Theme.Light)
      
      HStack {
        Group {
          Image(systemName: question.questionType.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
        }
        .frame(width: 24, height: 24)
        .foregroundColor(Theme.Light)
        
        Text("\(question.questionType.stringValue.capitalized)")
          .font(.subheadline)
          .foregroundColor(Theme.Light)
        Spacer()
      }
    }
    .foregroundColor(Theme.Light)
  }
}

struct QuestionStaticHeader_Previews: PreviewProvider {
  static var previews: some View {
    QuestionStaticHeader(question: .stub)
  }
}
