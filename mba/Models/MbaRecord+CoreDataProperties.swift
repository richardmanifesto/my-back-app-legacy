//
//  MbaRecord+CoreDataProperties.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//
//

import Foundation
import CoreData


extension MbaRecord {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MbaRecord> {
      return NSFetchRequest<MbaRecord>(entityName: "MbaRecord")
  }

  @NSManaged public var id: UUID?
  @NSManaged public var date: Date?
  @NSManaged public var value: Double
  @NSManaged public var type: String?
  @NSManaged public var subType: String?
  @NSManaged public var notes: String?
  
  var safeType: String {
    return type ?? ""
  }
  
  var valueFormatted: String {
    return MbaRecord.formatValue(recordType: safeType, value: value)
  }
  
  var time: String {
    if (date != nil) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm"
      return dateFormatter.string(from: date!)
    }
    else {
      return  ""
    }
  }
  
  var timestamp: Double {
    if (date != nil) {
      return date!.timeIntervalSince1970
    }
    else {
      return  0
    }
  }
  
  var dateFormatted: String {
    if (date != nil) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd/MM/YYYY"
      return dateFormatter.string(from: date!)
    }
    else {
      return  ""
    }
  }
  
  static func getOptionsForType(recordType: String) -> [Double] {
    var options = [Double]()
        
    switch(recordType) {
      case "sleep":
        for number in 0...14 {
          if (number != 0) {
            options.append(Double(number))
          }
          
          options.append(Double(number) + 0.5)
        }
          

        case "exercise":
          for number in 0...5 {
            if (number != 0) {
              options.append(Double(number))
            }
            
            options.append(Double(number) + 0.25)
            options.append(Double(number) + 0.50)
            options.append(Double(number) + 0.75)
          }

        default:
          for number in 0...10 {
            options.append(Double(number))
          }
      }
    
    return options
  }
  
  static func formatValue(recordType: String, value: Double) -> String {
    let mins = Int(60.0 * (value - floor(value)))
    
    switch(recordType) {
      case "pain":
        return "\(Int(value))"
      case "exercise":
      return "\(Int(floor(value))):\(mins)\(mins < 10 ? "0" : "")"
      case "sleep":
        return "\(Int(floor(value))):\(mins)\(mins < 10 ? "0" : "")"
      default:
        return ""
    }
  }

}

extension MbaRecord : Identifiable {

}
