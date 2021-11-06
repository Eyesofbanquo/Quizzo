//
//  HomeView.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/3/21.
//

import SwiftUI

struct HomeView: View {
  @State private var isTakingQuiz: Bool = false
  @StateObject private var cloud: CloudManager = CloudManager()
  
  var body: some View {
    ZStack {
      if !isTakingQuiz {
        QuizListView(cloud: cloud,
                     isTakingQuiz: $isTakingQuiz)
      }
      
      if isTakingQuiz {
        ContentView()
          .transition(.move(edge: .trailing))
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
