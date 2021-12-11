//
//  OfflineCreateQuestionView.swift
//  ocky
//
//  Created by Markim Shaw on 12/10/21.
//

import Foundation
import SwiftUI

struct OfflineCreateQuestionView: View {
  @State var questionName: String = ""
  @State var questionType: QuestionType = .editing
  @State var question: Question?
  @State var onSuccessAlert: Bool = false
  @State var qrCodeUrl: String = ""
  
  var dismissAction: () -> Void
  
  init(questionType: QuestionType,
       state: QuestionViewState,
       dismissAction: @escaping () -> Void) {
    self._questionType = State(initialValue: questionType)
    self.dismissAction = dismissAction
  }
  
  struct QRCodeView:  View {
    @Environment(\.openURL) var openURL
    @State var copiedText: Bool = false
    @Binding var qrCodeUrl: String
    var body: some View {
      ZStack {
        Theme.BG.ignoresSafeArea()
        
        VStack {
          Spacer()
          if qrCodeUrl.isEmpty == false {
            AsyncImage(url: URL(string: qrCodeUrl)) { image in
              image.resizable().aspectRatio(contentMode: .fit)
                .scaleEffect(0.5)
            } placeholder: {
              ProgressView().progressViewStyle(CircularProgressViewStyle())
                .tint(Theme.Light)
                .scaleEffect(1.2)
            }
          }
          Button(action: {
            copiedText.toggle()
            UIPasteboard.general.string = qrCodeUrl
          }) {
            if copiedText {
              Text("Copied QR Code Link" )
                .questionButton(isHighlighted: false,
                                defaultBackgroundColor: Theme.Red)
                .animation(.easeInOut(duration: 0.2), value: copiedText)
                
            } else {
              Text("Copy QR Code Link")
                .questionButton(isHighlighted: false,
                                defaultBackgroundColor: Theme.LightBlue)
                .animation(.easeInOut(duration: 0.2), value: copiedText)
            }
          }
          .disabled(copiedText)
          
          Button(action: {
            openURL(URL(string: qrCodeUrl)!)
          }) {
            Text("Open QR Code in Safari")
              .questionButton(isHighlighted: false,
                              defaultBackgroundColor: Theme.Yellow)
          }
          Spacer()
        }
      }
    }
  }
  
  var body: some View {
    ZStack {
      Theme.BG.ignoresSafeArea()
      VStack {
        HStack {
          Button(action: dismissAction) {
            Image(systemName: "xmark.circle")
              .resizable()
              .frame(width: 32, height: 32)
              .foregroundColor(Theme.Light)
          }
          Spacer()
          
        }
          .padding(.horizontal)
          .padding(.top)
        
        
        ScrollView {
//          if qrCodeUrl.isEmpty == false {
//            AsyncImage(url: URL(string: qrCodeUrl)) { image in
//              image.resizable().aspectRatio(contentMode: .fit)
//                .padding()
//                .scaleEffect(0.5)
//            } placeholder: {
//              ProgressView().progressViewStyle(CircularProgressViewStyle())
//                .tint(Theme.Light)
//                .scaleEffect(1.2)
//            }
//          }
          VStack {
            VStack(alignment: .leading) {
              HStack {
                Text("Create a Question")
                  .font(.title)
                  .bold()
                Spacer()
              }
              
              Text("This will be added to the Ocky DB.")
                .font(.headline)
                .foregroundColor(Theme.Light)
              
              HStack {
                Group {
                  Image(systemName: questionType.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }
                .frame(width: 24, height: 24)
                .foregroundColor(Theme.Light)
                
                Text("\(questionType.stringValue.capitalized)")
                  .font(.subheadline)
                  .foregroundColor(Theme.Light)
                Spacer()
              }
            }
            .foregroundColor(Theme.Light)
            QuestionViewDynamicHeader(questionName: $questionName,
                                      questionViewState: .editing)
            QuestionViewEditingBody(input: OfflineCreateQuestionEditingInput.generate(fromView: self))
              .sheet(isPresented: $onSuccessAlert) {
                dismissAction()
              } content: {
                QRCodeView(qrCodeUrl: $qrCodeUrl)
              }
          }
        }
        
        .padding()
      }
    }
  }
}
