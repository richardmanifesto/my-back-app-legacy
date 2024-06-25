//
//  TopTabsView.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import SwiftUI

struct TopTabsView: View {
  var tabs: [String]
  
  @Binding var selectedTab: Int
  
  var body: some View {
    GeometryReader { geo in
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          ForEach(0 ..< tabs.count, id: \.self) { tabIndex in
            Button(action: {
              withAnimation {
                selectedTab = tabIndex
              }
            },
            label: {
              VStack(spacing: 0) {
                HStack {
                  Text(tabs[tabIndex])
                }
                .frame(width: (geo.size.width / 3), height: 52)
                            
                Rectangle()
                  .fill(selectedTab == tabIndex ? Color.blue : Color.clear)
                  .frame(height: 3)
              }
           })
          }
        }
      }
    }
    .frame(height: 55)
  }
}

struct TopTabsView_Previews: PreviewProvider {
    static var previews: some View {
      TopTabsView(tabs: ["Pain", "Exercise", "Sleep"], selectedTab: .constant(0))
    }
}
