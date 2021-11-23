//
//  QuestionHistorySnippet.swift
//  ocky
//
//  Created by Markim Shaw on 11/23/21.
//

import SwiftUI
import GameKit

struct QuestionHistorySnippet: View {
  // MARK: - Properties -
  var player: String
  var question: Question
  var isCorrect: Bool
  
  private var imageSize: CGSize = CGSize(width: 16.0, height: 16.0)
  
  private var snippetColor: Color {
    question.player == player ? .blue : .gray
  }
  
  // MARK: - Init -
  init(player: String, question: Question, isCorrect: Bool) {
    self.question = question
    self.player = player
    self.isCorrect = isCorrect
  }
  
  var body: some View {
    HStack {
      VStack(alignment: .leading,
             spacing: 8.0) {
        Image(systemName: "paperplane.fill")
          .resizable()
          .frame(width: imageSize.width,
                 height: imageSize.height)
          .overlay(Circle()
                    .stroke(Color.white, lineWidth: 2.0)
                    .frame(width: imageSize.width * 2.0, height: imageSize.height * 2.0))
          .offset(x: imageSize.width / 2.0)
          .padding(.bottom, 8.0)
          .padding(.top, 8.0)
          .foregroundColor(isCorrect ? Color.green : Color.red)
        
        Text("\(question.player)'s Question")
          .foregroundColor(Color.white)
          .opacity(0.95)
        
        Text(question.name)
          .font(.largeTitle)
          .bold()
          .foregroundColor(Color.white)
          .padding(.bottom, 8.0)
          .fixedSize(horizontal: false, vertical: true)
      }
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(RoundedRectangle(cornerRadius: 16.0)
                  .fill(snippetColor)
                  .shadow(color: Color.black.opacity(0.3), radius: 10.0, x: 0, y: 10))
    .padding()
  }
}

struct QuestionHistorySnippet_Previews: PreviewProvider {
  static var previews: some View {
    QuestionHistorySnippet(player: "MLShaw",
                           question: .stub,
                           isCorrect: true)
      .previewLayout(.sizeThatFits)
  }
}
