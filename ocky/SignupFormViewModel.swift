//
//  SignupFormViewModel.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import Foundation
import Combine
import SwiftUI

class SignupFormViewModel: ObservableObject {
  @Published var username: String = ""
  @Published var password: String = ""
  @Published var repeatPassword: String = ""
  @Published var isValid: Bool = false
  
  init() {
    Publishers.CombineLatest3($username, $password, $repeatPassword)
      .map { (username, password, repeatPassword) in
        print(username, password, repeatPassword)

        guard username.count > 0 && password.count > 0 && repeatPassword.count > 0 else {
          return false
        }
        
        return true
      }
      .assign(to: &$isValid)
  }
}
