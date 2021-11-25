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
  var highlightedColor: Color
  
  init(isHighlighted: Bool,
       defaultBackgroundColor: Color = .pink,
       defaultForegroundColor: Color = .white,
       highlightedColor: Color = Theme.LightGreen) {
    self.isHighlighted = isHighlighted
    self.defaultBackgroundColor = defaultBackgroundColor
    self.defaultForegroundColor = defaultForegroundColor
    self.highlightedColor = highlightedColor
  }
  func body(content: Content) -> some View {
    content
      .foregroundColor(defaultForegroundColor)
      .frame(maxWidth: .infinity)
      .padding()
      .background(RoundedRectangle(cornerRadius: 16.0)
                    .fill(isHighlighted ? highlightedColor : defaultBackgroundColor))
      .padding()
  }
}
