//
//  QuestionType.swift
//  ocky
//
//  Created by Markim Shaw on 12/2/21.
//

import Foundation

enum QuestionType: Int, Codable, CaseIterable {
  case multipleChoice
  case singleChoice
  case trueOrFalse
  case editing
  
  var stringValue: String {
    switch self {
      case .multipleChoice: return "multiple choice"
      case .singleChoice: return "single choice"
      case .trueOrFalse: return "true or false"
      case .editing: return "editing"
    }
  }
  
  var imageName: String {
    switch self {
      case .multipleChoice: return "die.face.6.fill"
      case .singleChoice: return "die.face.1.fill"
      case .trueOrFalse: return "graduationcap.fill"
      default: return ""
    }
  }
}
