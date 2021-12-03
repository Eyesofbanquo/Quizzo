//
//  QuestionType.swift
//  ocky
//
//  Created by Markim Shaw on 12/2/21.
//

import Foundation

enum QuestionType: String, Codable, CaseIterable {
  case multipleChoice = "multiple choice"
  case singleChoice = "single choice"
  case trueOrFalse = "true or false"
  case editing
  
  var imageName: String {
    switch self {
      case .multipleChoice: return "die.face.6.fill"
      case .singleChoice: return "die.face.1.fill"
      case .trueOrFalse: return "graduationcap.fill"
      default: return ""
    }
  }
}
