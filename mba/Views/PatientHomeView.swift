//
//  PatientHomeView.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import SwiftUI

struct PatientHomeView: View {
  @ObservedObject public var dataController: DataController
  
  var body: some View {
    TabView {
      NavigationView {
        MyDayView(date: Date.now, dataController: dataController)
      }
      .tabItem {
        Label("My day", systemImage: "square.and.pencil")
      }
      
      ReportsView(dataController: dataController)
        .tabItem {
          Label("Reports", systemImage: "square.and.pencil")
        }
      
      Text("Personal details")
        .tabItem {
          Label("Personal details", systemImage: "square.and.pencil")
        }
    }
  }
}

struct PatientHomeView_Previews: PreviewProvider {  
  static var previews: some View {
    PatientHomeView(dataController: DataController())
  }
}
