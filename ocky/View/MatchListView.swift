//
//  MatchListView.swift
//  ocky
//
//  Created by Markim Shaw on 11/8/21.
//

import SwiftUI
import GameKit

struct MatchListView: View {
  @EnvironmentObject var handler: MLGame
  let matches: [Matchable]
  
  func isUserTurn(forMatch match: Matchable) -> Bool {
    GKLocalPlayer.local.displayName == match.currentParticipant
  }
  
  var body: some View {
    ZStack {
      VStack {
        Header()
        if matches.isEmpty {
          Spacer()
        }
        if matches.count > 0 {
          ScrollView {
            MatchList()
              .zIndex(1.0)
          }
          Spacer()
        } else {
          VStack {
            Image(systemName: "rectangle.and.pencil.and.ellipsis")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .scaleEffect(0.5)
            Text("No games in progress...")
              .font(.largeTitle)
              .bold()
            
          }
          Spacer()
        }
        
      }
      .zIndex(1.0)
      
      VStack {
        HStack {
          Spacer()
          Text("Your matches")
            .font(.title2)
            .bold()
            .foregroundColor(Color(uiColor: .label))
            .padding()
            
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
          .resizable()
          .frame(width: 32, height: 32)
          .foregroundColor(Color(uiColor: .label))
          .padding()
      }
      .buttonStyle(PlainButtonStyle())
      Spacer()
    }
  }
  
  private func MatchList() -> some View {
    LazyVStack {
      ForEach(matches, id: \.id) { match in
        MatchView(match: match, isPlayerInTurn: isUserTurn(forMatch: match))
          .zIndex(2.0)
          .onTapGesture {
            Task {
              self.handler.setState(.loadMatch(matchID: match.id))
              try await self.handler.loadMatch(matchID: match.id)
            }
          }
      }
    }
  }
}
