//
//  ChartLabelView.swift
//  mba
//
//  Created by Richard Hanson on 04/04/2022.
//

import SwiftUI

struct ChartLabelView: View {
  var item: ChartDataPoint
  
  var body: some View {
    print(item.label.count)
    
    return VStack {
      Text("\(item.label)")
        .frame(width: 100, alignment: .center)
        .padding(8)
        .font(.caption)
        .background(.green)
        .cornerRadius(4)
        
    }
  }
    
}

//struct ChartLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChartLabelView()
//    }
//}
