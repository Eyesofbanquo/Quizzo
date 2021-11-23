//
//  QuestionViewResultsBody.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import SwiftUI

struct QuestionViewResultsBody: View {
  var choices: [Answer]
  
  var body: some View {
    VStack(alignment: .leading) {
      ForEach(choices) { choice in
        Text(choice.text)
          .questionButton(isHighlighted: false)
      }
      HStack(spacing: 8.0) {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
          .foregroundColor(.white)
        Text("Waiting on other player")
      }
      .foregroundColor(Color.white)
      .frame(maxWidth: .infinity)
      .padding()
      .background(RoundedRectangle(cornerRadius: 16.0)
                    .fill(Color.green)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 10.0, x: 0, y: 10))
      .padding()
    }
  }
}

struct QuestionViewResultsBody_Previews: PreviewProvider {
  static var previews: some View {
    QuestionViewResultsBody(choices: [Answer(isCorrect: true, text: "Markim"),
                                      Answer(isCorrect: false, text: "Shaw")])
  }
}
