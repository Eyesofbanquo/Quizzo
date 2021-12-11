//
//  OfflineCreateQuestionEditingInput.swift
//  ocky
//
//  Created by Markim Shaw on 12/10/21.
//

import Foundation
import SwiftUI

struct OfflineCreateQuestionEditingInput: EditingBodyInput {
  var questionName: Binding<String>
  var currentPlayer: String
  var addQuestionToHistory: (Question) -> Void
  var endTurn: () -> Void
  var questionType: Binding<QuestionType>
  
  static var url: URL? {
    #if DEBUG
    URL(string: "http://localhost:3000/q")
    #else
    URL(string: "https://ocky-api.herokuapp.com/q")
    #endif
  }
  
  static func generate(fromView view: OfflineCreateQuestionView) -> OfflineCreateQuestionEditingInput {
    return OfflineCreateQuestionEditingInput(questionName: view.$questionName, currentPlayer: "Anonymous Creator", addQuestionToHistory: { question in
      /* This doesn't matter */
      view.question = question
    }, endTurn: {
      /* This is where the network call is made */
      let session = URLSession.shared
      guard let url = url, let question = view.question else { return }
      
      let data = try? JSONEncoder().encode(question)
      
      Task {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = data
        let (data, response) = try await session.data(for: request)
        
        let responseBody = try? JSONDecoder().decode(ResponseBody.self, from: data)
        
        await MainActor.run {
          if let qrcode = responseBody?.body.qrcode {
            print(qrcode)
            view.onSuccessAlert.toggle()
            view.qrCodeUrl = qrcode
          }
        }
       
//        
//        if (response as? HTTPURLResponse)?.statusCode ?? 0 > 200 {
//          await MainActor.run {
//            /* Present modal saying QR Code is ready then launch*/
//            view.dismissAction()
//          }
//        }
      }
    }, questionType: view.$questionType)
  }
}

fileprivate struct ResponseBody: Codable {
  var body: QRCodeBody
}

fileprivate struct QRCodeBody: Codable {
  var qrcode: String
}
