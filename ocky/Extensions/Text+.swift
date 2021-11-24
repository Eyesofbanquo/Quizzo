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
                      defaultForegroundColor: Color = .white) -> some View {
    self
      .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted,
                                                 defaultBackgroundColor: defaultBackgroundColor,
                                                 defaultForegroundColor: defaultForegroundColor))
  }
  
  func questionButtonWithLoading(isHighlighted: Bool,
                                 defaultBackgroundColor: Color = .pink,
                                 defaultForegroundColor: Color = .white) -> some View {
    HStack {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle())
      self
        .modifier(QuestionViewAnswerButtonModifier(isHighlighted: isHighlighted,
                                                   defaultBackgroundColor: defaultBackgroundColor,
                                                   defaultForegroundColor: defaultForegroundColor))
    }
  }
}
