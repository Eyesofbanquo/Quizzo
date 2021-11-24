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
  var defaultBackgroundColor: Color
  var defaultForegroundColor: Color
  
  init(isHighlighted: Bool,
       defaultBackgroundColor: Color = .pink,
       defaultForegroundColor: Color = .white) {
    self.isHighlighted = isHighlighted
    self.defaultBackgroundColor = defaultBackgroundColor
    self.defaultForegroundColor = defaultForegroundColor
  }
  func body(content: Content) -> some View {
    content
      .foregroundColor(defaultForegroundColor)
      .frame(maxWidth: .infinity)
      .padding()
      .background(RoundedRectangle(cornerRadius: 16.0)
                    .fill(isHighlighted ? Color.green : defaultBackgroundColor))
      .padding()
  }
}
