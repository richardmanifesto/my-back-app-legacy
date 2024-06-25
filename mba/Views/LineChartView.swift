//
//  LineChartView.swift
//  mba
//
//  Created by Richard Hanson on 04/04/2022.
//

import SwiftUI

struct LineChartViewGridlines: View {
  var maxGridX: Int
  var maxGridY: Int
  var hasTouched: Bool
  var vLine: Int
  var height: Double
  var width: Double
  
  var body: some View {
    ForEach(0...maxGridY, id: \.self) { row in
      let yPos = CGFloat(row) * (height / CGFloat(maxGridY))

      Path { path in
        path.move(to: CGPoint(x: 0, y: yPos))
        path.addLine(to: CGPoint(x: width, y: yPos))
        path.closeSubpath()
      }
      .stroke(Color(UIColor.systemGray3), style: StrokeStyle(lineWidth: 1, lineJoin: .round))
    }
    
    ForEach(0...maxGridX, id: \.self) { row in
      Path { path in
        let xPos = CGFloat(row) * (width / CGFloat(maxGridX))

        path.move(to: CGPoint(x: xPos, y: 0))
        path.addLine(to: CGPoint(x: xPos, y: height))
        path.closeSubpath()
      }
      .stroke(hasTouched && vLine == row ? Color(UIColor.darkGray) : Color(UIColor.systemGray3), style: StrokeStyle(lineWidth: hasTouched && vLine == row ? 3 : 1, lineJoin: .round))
    }
  }
}

struct LineChartView: View {
  var dataPoints: ChartData
  
  @State var textXPos   = 0.0
  @State var textYPos   = 0.0
  @State var hastouched = false

//  var highestPoint: Double {
//    let max = dataPoints.max() ?? 1.0
//    if max == 0 { return 1.0 }
//    return max
//  }
//
//  var max: Int {
//    let max = dataPoints.max() ?? 1.0
//    if max == 0 { return 1 }
//    return Int(max.rounded(.up))
//  }

  var body: some View {
    GeometryReader { geometry in
      let height     = geometry.size.height
      let width      = geometry.size.width
      let pointCount = dataPoints.points.count
      let vLine      = textXPos == 0.0 ? 0.00 : (Double(pointCount - 1) * ((textXPos - 16) / geometry.size.width)).rounded()
      let selectedIndex      = Int(vLine)
      let maxGridY   = Int(dataPoints.maxValue.rounded(.up) + 1)
    
      ForEach(0...maxGridY, id: \.self) { row in
        let yPos = CGFloat(row) * (height / CGFloat(maxGridY))
        
        Text("\(maxGridY - row)")
          .border(Color.green)
          .offset(x: -14, y: yPos - 14)
          .font(.caption)
          .frame(alignment: .bottomLeading)
          
      }
      
      ForEach(0..<dataPoints.labelsArray.count) { index in
        Text("\(dataPoints.labelsArray[index].label)")
          .frame(width: (width - 32) * (Double(dataPoints.labelsArray[index].count) / Double(dataPoints.points.count)),  alignment: .leading)
//          .frame(width: width,  alignment: .center)
//          .font(.system(size: 8))
          .font(.caption)
          .border(.green)
//          .
          
          .offset(x: (width - 32) * dataPoints.labelOffsetGet(index: index), y: height)
//          .offset(x: 0, y: height)
      }
      
      LineChartViewGridlines(maxGridX: dataPoints.dataPointsArray.count, maxGridY: maxGridY, hasTouched: hastouched, vLine: Int(vLine), height: height, width: width)
      
//      ForEach(0...maxGridY, id: \.self) { row in
//        let yPos = CGFloat(row) * (height / CGFloat(maxGridY))
//
//        Path { path in
//          path.move(to: CGPoint(x: 0, y: yPos))
//          path.addLine(to: CGPoint(x: width, y: yPos))
//          path.closeSubpath()
//        }
//        .stroke(Color(UIColor.systemGray3), style: StrokeStyle(lineWidth: 1, lineJoin: .round))
//      }
//
      
//
      Path { path in
        path.move(to: CGPoint(x: 0, y: Double(height)))
        
        for (index, item) in dataPoints.dataPointsArray.enumerated() {
          path.addLine(to:
            CGPoint(
              x: CGFloat(index) * width / CGFloat(pointCount - 1),
              y: height - (height * ratio(for: item.average))
            )
          )
        }
      }
      .stroke(Color.accentColor, style: StrokeStyle(lineWidth: 5, lineJoin: .round))
      
//      if (hastouched && dataPoints.dataPointsArray[Int(vLine)]) {
//        ChartLabelView(item: dataPoints.dataPointsArray[Int(vLine)])
//      }
      
      if (hastouched) {
//          dataPoints.getItemAt(index: selectedIndex)
        ChartLabelView(item: dataPoints.getItemAt(index: selectedIndex))
          .position(x: textXPos > (width - 50) ? (width - 50) : textXPos, y: ((geometry.frame(in: .local).midY) - (height / 2)))
//          Text("\(selectedIndex)")
      }
      
//      if (hastouched) {
//        ChartLabelView()
//        .position(x: textXPos > (width - 80) ? (width - 80) : textXPos, y: ((geometry.frame(in: .local).midY) - (height / 2)))
//      }
    }
    .padding()
    .background(Color(UIColor.systemGray6))
    .frame(maxHeight: 300)
    .gesture(DragGesture(minimumDistance: 0).onEnded({ (value) in
      textXPos = value.location.x
      hastouched = true
      textYPos = value.location.y
    }))
    .cornerRadius(8)

  }

  private func ratio(for value: Double) -> Double {
//    print("V: \(value) \(dataPoints.maxValue) \(value / dataPoints.maxValue)")
    return value / (dataPoints.maxValue + 1)
  }
}
