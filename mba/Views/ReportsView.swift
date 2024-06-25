//
//  ReportsView.swift
//  mba
//
//  Created by Richard Hanson on 03/04/2022.
//

import SwiftUI

struct ReportsView: View {
  @ObservedObject public var dataController: DataController
  @State var chartType = "month"
  
  var options: [String: String] = [
    "week"        : "Week",
    "month"       : "Month",
    "three-months": "3 months"
  ]
  
  
//  func averageGet(values: [Double]) -> Double {
//    return values.reduce(0, { x, y in
//        x + y
//    }) / Double(values.count)
//  }
  
  func chartDataGet() -> ChartData {
    switch(chartType) {
    case "month":
      return ChartData(for: dataController.getRecordsForLastMonthByType(for: Date.now, by: "pain"), by: chartType)
    case "three-months":
      return ChartData(for: dataController.getRecordsForLastThreeMonthsByType(for: Date.now, by: "pain"), by: chartType)
    default:
      return ChartData(for: dataController.getRecordsForLastSevenDaysByType(for: Date.now, by: "pain"), by: chartType)
    }
    
    
//    return ChartData(for: dataController.getRecordsForLastSevenDaysByType(for: Date.now, by: "pain"), by: chartType)
    
    
  
  }

  
  var body: some View {
//    let records = dataController.getRecordsForLastMonthByType(for: Date.now, by: "pain")
    
//    let records = mapData()
    
    return VStack {
      Picker("Please choose", selection: $chartType) {
        ForEach(Array(options.keys), id: \.self) { key in
          Text("\(options[key]!)")
        }
      }
      .pickerStyle(.segmented)
      .padding(.bottom)
      
      Text("Selection \(chartType)")
      
      LineChartView(dataPoints: chartDataGet())
      Spacer()
      
//      List {
//        ForEach(Array(records.keys).sorted(), id: \.self) { key in
//          HStack {
//            Text("\(niceDateGet(timestamp: key))")
//            Spacer()
//            Text("\(averageGet(values: records[key] ?? [0.0]))")
//          }
//        }
//
//      }
//      .listStyle(PlainListStyle())
      
//      LineChartView(dataPoints: dataPointsGet(records: records))
//        .padding()
    }
    .padding()
  }
}

struct ReportsView_Previews: PreviewProvider {
  static var previews: some View {
    let dataController = DataController(inMemory: true)
    TestData.generateTestData(dataController: dataController)
    
    return ReportsView(dataController: dataController)
  }
}
