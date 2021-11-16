//
//  MatchListView.swift
//  ocky
//
//  Created by Markim Shaw on 11/8/21.
//

import SwiftUI

struct MatchListView: View {
  @EnvironmentObject var handler: MLGame
  let matches: [Matchable]
  
  var body: some View {
    ZStack {
      VStack {
        Header()
        ScrollView {
          MatchList()
            .zIndex(1.0)
        }
        
        Spacer()
      }
      .zIndex(1.0)
      
      VStack {
        HStack {
          Spacer()
          Text("Your matches")
            .padding()
            .font(.headline)
          Spacer()
        }
        Spacer()
      }
      .zIndex(2.0)
    }
  }
}


struct MatchListView_Previews: PreviewProvider {
  static var previews: some View {
    MatchListView(matches: [])
      .environmentObject(MLGame.stub)
  }
}

extension MatchListView {
  private func Header() -> some View {
    HStack {
      Button(action: {
        handler.setState(.idle)
      }) {
        Image(systemName: "xmark.circle.fill")
          .padding()
      }
      .buttonStyle(PlainButtonStyle())
      Spacer()
    }
  }
  
  private func MatchList() -> some View {
    LazyVStack {
      ForEach(matches, id: \.id) { match in
        MatchView(match: match, isPlayerInTurn: handler.isUserTurn)
          .zIndex(2.0)
          .onTapGesture {
            Task {
              try await self.handler.loadMatch(matchID: match.id)
            }
          }
      }
    }
  }
}
