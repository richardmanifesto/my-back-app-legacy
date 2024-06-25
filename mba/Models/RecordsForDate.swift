//
//  RecordsForDate.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import Foundation

class RecordsForDate: ObservableObject {
  @Published var pain    : [MbaRecord] = []
  @Published var exercise: [MbaRecord] = []
  @Published var sleep   : [MbaRecord] = []
  
  
  /// Intialise form a data set
  /// - Parameter records: An array of records for the given date
  init(from records: [MbaRecord]) {
    for record in records {
      switch(record.type) {
        case "pain":
          pain.append(record)
        case "exercise":
          exercise.append(record)
        case "sleep":
          sleep.append(record)
        default: break
      }
    }
  }
  
  static func typesGet() -> [String] {
    return ["pain", "exercise", "sleep"]
  }
  
  func hasRecordsForType(type: String) -> Bool {
    switch(type) {
    case "pain":
      return pain.count > 0
    case "exercise":
        return exercise.count > 0
    case "sleep":
        return sleep.count > 0
    default:
      return false
    }
  }
  
  func getRecordsForType(type: String) -> [MbaRecord] {
    switch(type) {
    case "pain":
        return pain
    case "exercise":
        return exercise
    case "sleep":
        return sleep
    default:
      return []
    }
  }
  
  func removeRecordsForType(type: String, index: IndexSet) -> Void {
    switch(type) {
    case "pain":
      pain.remove(atOffsets: index)
    case "exercise":
      exercise.remove(atOffsets: index)
    case "sleep":
      sleep.remove(atOffsets: index)
    default: break
    }
  }
  
  func recordAdd(type: String, record: MbaRecord) {
    switch(type) {
    case "pain":
      pain.append(record)
    case "exercise":
      exercise.append(record)
    case "sleep":
      sleep.append(record)
    default:
      break
    }
  
  }
}
