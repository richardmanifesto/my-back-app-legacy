//
//  mbaApp.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import CoreData
import SwiftUI

@main
struct mbaApp: App {
  @StateObject private var dataController = DataController()
  
  @AppStorage("hasLaunched") var hasLaunched: Bool = false
  
  var body: some Scene {
    
    #if DEBUG
      print("app folder path is \(NSHomeDirectory())")
    
      if (!hasLaunched) {
        TestData.generateTestData(dataController: dataController)
        hasLaunched = true
      }
      else {
        print("Has previously launched")
      }
    #endif

    return WindowGroup {
      VStack {
        PatientHomeView(dataController: dataController)
      }
    }
  }
}
