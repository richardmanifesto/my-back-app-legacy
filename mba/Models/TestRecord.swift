//
//  TestRecord.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import Foundation

struct TestRecord: Decodable {
  var type : String
  var date : Date
  var value: Double
  var notes: String?
  
  enum CodingKeys: String, CodingKey {
    case type
    case date
    case value
    case notes
  }
  
   init(from decoder: Decoder) throws {
     let container = try decoder.container(keyedBy: CodingKeys.self)
     
     
     let dateString = try container.decode(String.self, forKey: .date)
     let dateFormatter = DateFormatter()
     dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
     dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
     
     type  = try container.decode(String.self, forKey: .type)
     date  = dateFormatter.date(from: dateString)!
     value = try container.decode(Double.self, forKey: .value)
     notes = try container.decode(String.self, forKey: .notes)
  }
}
