//
//  NetworkResponses.swift
//  ocky
//
//  Created by Markim Shaw on 12/6/21.
//

import Foundation

struct QuestionResponse: Decodable {
  var id: String
  var name: String
  var type: Int
  var player: String?
  var choices: [AnswerResponse]
}

struct AnswerResponse: Decodable {
  var id: String
  var text: String
  var isCorrect: Bool
  
  enum CodingKeys: String, CodingKey {
    case id, text
    case isCorrect = "is_correct"
  }
}

struct OckyQuestionNetworkResponse: Decodable {
  var status: Int
  var body: OckyQuestionNetworkResponseBody
}

struct OckyQuestionNetworkResponseBody: Decodable {
  var question: QuestionResponse
}
