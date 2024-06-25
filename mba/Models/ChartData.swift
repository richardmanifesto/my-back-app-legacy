//
//  ChartData.swift
//  mba
//
//  Created by Richard Hanson on 04/04/2022.
//

import Foundation

struct ChartDataPoint: Hashable {
  var timestamp : Double
  var label     : String
  var items     : [Double]
  
  var average: Double {
    return items.reduce(0, { x, y in
      x + y
    }) / Double(items.count)
  }
}

struct ChartLabel: Hashable {
  var label: String
  var count: Int
}

class ChartData {
  var grouping: String
  var points  : [Double: ChartDataPoint] = [:]
  var maxValue: Double =  1.0
  var labels  : [String: ChartLabel] = [:]
  
  var dataPointsArray: [ChartDataPoint] {
    var itemArray = [ChartDataPoint]()
    
    for(item) in Array(points.keys).sorted().reversed() {
      itemArray.append(points[item]!)
    }
  
    return itemArray
  }
  
  var labelsArray: [ChartLabel] {
    var itemArray = [ChartLabel]()
    
    for(item) in Array(labels.keys) {
      itemArray.append(labels[item]!)
    }
  
    return itemArray
  }
  
  init(for data: [MbaRecord], by grouping: String) {
    self.grouping = grouping

    
    switch(grouping) {
    case "three-months":
      self.points = dataGroupByWeek(on: data)
    default:
      self.points = dataGroupByDay(on: data)
    }
    
    for label in labelsArray {
      print(label.count)
      print(points.count)
      
//      print(label.count / dataPointsArray.count)
    }
    
//    print(points)
  }
  
  func labelOffsetGet(index: Int) -> Double {
    var offset = 0
    
    for (labelIndex, label) in labelsArray.enumerated() {
      if (labelIndex < index) {
        offset += label.count
      }
    }
    
    print("Index \(index) \(offset) \(Double(offset) / Double(points.count))")
    
    return offset == 0 ? 0.0 : Double(offset) / Double(points.count)
  }
  
  func getItemAt(index: Int) -> ChartDataPoint {
//    print(Array(points.keys).sorted().reversed())
    return dataPointsArray[index]
  }
  
  private func dataGroupByDay(on data: [MbaRecord]) -> [Double: ChartDataPoint] {
    var itemMap: [Double: ChartDataPoint] = [:]
    
    for record in data {
      let dayDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: record.date!)!
      
      if var item = itemMap[dayDate.timeIntervalSince1970] {
        item.items.append(record.value)
      }
      else {
        let newItem = ChartDataPoint(timestamp: dayDate.timeIntervalSince1970, label: record.dateFormatted, items: [record.value])
        itemMap[dayDate.timeIntervalSince1970] = newItem
      }
      
      if (record.value > maxValue) {
        maxValue = record.value
      }
      
      let labelString = labelGet(for: dayDate)
      
      if var label = labels[labelString] {
//        print("labs \(labelString)")
        labels[labelString]!.count += 1
      }
      else {
        labels[labelString] = ChartLabel(label: labelString, count: 1)
      }
//      print(labelGet(for: dayDate))
    }
  
  
    return itemMap
  }
  
  private func dataGroupByWeek(on data: [MbaRecord]) -> [Double: ChartDataPoint] {
    var itemMap: [Double: ChartDataPoint] = [:]
    var calendar = Calendar(identifier: .gregorian)
    let timezone = TimeZone(secondsFromGMT: 0)!
    calendar.timeZone = timezone
    
    
    for record in data {
//      let week = calendar.component(.weekOfYear, from: record.date!)
      
      let weekDate = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: record.date!).date!

      
      if var item = itemMap[weekDate.timeIntervalSince1970] {
        item.items.append(record.value)
      }
      else {
        let label = weekLabelGet(for: weekDate)
        
        print(label)
        
        let newItem = ChartDataPoint(timestamp: weekDate.timeIntervalSince1970, label: label, items: [record.value])
        itemMap[weekDate.timeIntervalSince1970] = newItem
      }
      
      if (record.value > maxValue) {
        maxValue = record.value
      }
      
      let labelString = labelGet(for: weekDate)
      
      
      if var label = labels[labelString] {
       
        label.count += 1
      }
      else {
        labels[labelString] = ChartLabel(label: labelString, count: 1)
      }
    }
    
    return itemMap
  }
  
  func labelGet(for date: Date) -> String {
    let dateFormatter = DateFormatter()
    
    var calendar = Calendar(identifier: .gregorian)
    let timezone = TimeZone(secondsFromGMT: 0)!
    calendar.timeZone = timezone
    
    switch(grouping) {
    case "three-months":
      dateFormatter.dateFormat = "MMM"
      return dateFormatter.string(from: date)
    case "month":
      let weekDate = calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: date).date!
      
      dateFormatter.dateFormat = "d MMM"
      return dateFormatter.string(from: weekDate)
    default:
      dateFormatter.dateFormat = "E"
      return dateFormatter.string(from: date)
    }
  }
  
  
  func weekLabelGet(for date: Date) -> String {
    let startDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
    
    var dayComponent = DateComponents()
    dayComponent.day = 7
    let endDate      = Calendar.current.date(byAdding: dayComponent, to: startDate)!
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d MMM"
    return "\(dateFormatter.string(from: date)) - \(dateFormatter.string(from: endDate))"
  }
}
