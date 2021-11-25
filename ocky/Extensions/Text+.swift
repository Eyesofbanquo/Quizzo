//
//  Text+.swift
//  ocky
//
//  Created by Markim Shaw on 11/10/21.
//

import Foundation
import SwiftUI

extension Text {
  func questionButton(isHighlighted: Bool,
                      defaultBackgroundColor: Color = .pink,
                      defaultForegroundColor: Color = .white,
                      highlightedColor: Color = Theme.LightGreen) -> some View {
    self
      .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted,
                                                 defaultBackgroundColor: defaultBackgroundColor,
                                                 defaultForegroundColor: defaultForegroundColor,
                                                 highlightedColor: highlightedColor))
  }
  
  func questionButtonWithLoading(isHighlighted: Bool,
                                 defaultBackgroundColor: Color = .pink,
                                 defaultForegroundColor: Color = .white,
                                 highlightedColor: Color = Theme.LightGreen) -> some View {
    HStack {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      self
        .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted,
                                                   defaultBackgroundColor: defaultBackgroundColor,
                                                   defaultForegroundColor: defaultForegroundColor,
                                                   highlightedColor: highlightedColor))
    }
  }
}
