//
//  TestData.swift
//  mba
//
//  Created by Richard Hanson on 03/04/2022.
//

import Foundation

class TestData {
  
  /// Generate test data and store in CoreData
  /// - Returns: Viod
  static func generateTestData(dataController: DataController) -> Void {
    let testData = Bundle.main.decode([TestRecord].self, from: "test-records.json")
    let moc = dataController.container.viewContext
      
    for testRecord in testData {
      let newRecord   = MbaRecord(context: moc)
      newRecord.id    = UUID()
      newRecord.type  = testRecord.type
      newRecord.value = testRecord.value
      newRecord.date  = testRecord.date
    }
      
    do {
      try moc.save()
    }
    catch {
      print("Failed to generate test data: \(error)")
    }
      
  }
}
