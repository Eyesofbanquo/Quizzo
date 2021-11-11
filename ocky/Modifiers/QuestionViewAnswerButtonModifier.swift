//
//  QuestionViewAnswerButtonModifier.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import Foundation
import SwiftUI

struct QuestionViewAnswerButtonModifier: ViewModifier {
  var isHighlighted: Bool
  func body(content: Content) -> some View {
    content
      .foregroundColor(Color.white)
      .frame(maxWidth: .infinity)
      .padding()
      .background(RoundedRectangle(cornerRadius: 16.0)
                    .fill(isHighlighted ? Color.green : Color.pink)
                    .shadow(color: Color.black.opacity(0.3),
                            radius: 10.0, x: 0, y: 10))
      .padding()
  }
}
