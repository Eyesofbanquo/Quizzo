//
//  CloudManager.swift
//  SignsUp
//
//  Created by Markim Shaw on 11/4/21.
//

import Foundation
import CloudKit
import SwiftUI

class CloudManager: ObservableObject {
  private let database = CKContainer.default().publicCloudDatabase
  
  func create(question: Question) async throws {
    let record: CKRecord = CKRecord(recordType: "Question")
    let answerRecords: [CKRecord.Reference] = question.choices.map { choice in
      let record = CKRecord(recordType: "Answer")
      record.setValuesForKeys(["text": choice.text, "isCorrect": choice.isCorrect ? 1 : 0])
      let ref = CKRecord.Reference(record: record, action: .none)
      return ref
    }
    record.setValuesForKeys(["text": question.name, "choices": answerRecords])
    
    do {
      try await database.save(record)
    } catch {
      print(error.localizedDescription)
    }
  }
}
