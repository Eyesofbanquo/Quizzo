//
//  TextFieldType.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import Foundation

enum TextFieldType: String {
  case username = "Username"
  case password = "Password"
  case repeatPassword = "Repeat Password"
  
  var imageName: String {
    switch self {
      case .username: return "person"
      case .password: return "ellipsis.rectangle"
      case .repeatPassword: return "ellipsis.rectangle.fill"
    }
  }
}
