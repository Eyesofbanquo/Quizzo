//
//  QuizMainView.swift
//  ocky
//
//  Created by Markim Shaw on 12/3/21.
//

import SwiftUI

struct QuizMainView: View {
  @EnvironmentObject var ockyStateManager: OckyStateManager

  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      
      HomeHeaderView
      
      VStack {
        Button(action: {}) {
          VStack {
            Image(systemName: "barcode.viewfinder")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .font(.largeTitle)
              .foregroundColor(Theme.Yellow)
            Text("Scan App Clip")
              .font(.title)
              .foregroundColor(Theme.Yellow)
          }
        }
      }
      .padding()
    }
  }
  
  private var HomeHeaderView: some View {
    VStack {
      HomeAccessPoint {
        ockyStateManager.send(.menu)
      }
      .padding(.top)
      Spacer()
    }
  }
}

struct QuizMainView_Previews: PreviewProvider {
  static var previews: some View {
    QuizMainView()
      .environmentObject(OckyStateManager())
  }
}
