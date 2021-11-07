//
//  MainView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI

struct MainView: View {
  // MARK: - State -
  
  @AppStorage("signup") private var signup: Bool = false
  
  @State private var gameStarted: Bool = false
  
  var body: some View {
    MLGame(gameStarted: .constant(false))
//    ZStack {
//      if signup == false {
//        ContentView()
//      }
//
//      if signup == true {
//        HomeView()
//      }
//    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
