//
//  MyDayView.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import SwiftUI

struct MyDayView: View {
  var date: Date
  var types:[String] = RecordsForDate.typesGet()
  @State var updated: String = "\(NSDate().timeIntervalSince1970)"
  
  @ObservedObject public var dataController: DataController
  @State private var selectedTab: Int = 0
  @State private var isPresentingEditView = false
  @State private var currentRecord: MbaRecord?
  
  
  var currentType: String {
    return types[selectedTab]
  }
  
  func newRecord() -> MbaRecord {
    let record  = MbaRecord(context: dataController.container.viewContext)
    record.id   = UUID()
    record.type = currentType
    record.date = date
    return record
  }
  
  var body: some View {
    print("PP \(updated)")
    print("YY")
    print(currentRecord)
    
    return VStack(spacing: 0) {
      TopTabsView(tabs: types, selectedTab: $selectedTab)
        
      TabView(selection: $selectedTab,
        content: {
          ScrollView {
            VStack {
              Text("How is your \(currentType) today")
                .font(.title2)
                .fontWeight(.bold)
              
              MbaRecordFormView(type: currentType) { value, notes in
                let newRecord = MbaRecord(context: dataController.container.viewContext)
                newRecord.id    = UUID()
                newRecord.type  = currentType
                newRecord.date  = date
                newRecord.value = value
                newRecord.notes = notes
                
                try? dataController.container.viewContext.save()
                updated = "\(NSDate().timeIntervalSince1970)"
              }
              
              Section {
                let records = dataController.getRecordsForDateByType(for: date, by:currentType)
                
//                let records = ["One", "Two", "Three", "Four"]
                
                VStack {
                  Text("History")
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                  
                  if (records.isEmpty) {
                    Text("No records yet")
                      .italic()
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .padding(.top)
                  }
                  else {
                    List {
                      ForEach(records, id: \.self) { record in
                        HStack {
                          Text("\(record.time)")
                          Spacer()
                          Text("\(record.valueFormatted)")
                        }
                        .onTapGesture {
                          print(record)
                          
                          currentRecord = record
                          isPresentingEditView = true
                          
                          
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: -0, trailing: 0))
                      }
                      .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                    .frame(height: 40 + (50 * CGFloat(records.count)))
                    
                  }
                }
              }
              .padding(.top, 40)
            }
            .tag(0)
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
          }
        
        })
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      }
      .navigationBarHidden(true)
      .sheet(isPresented: $isPresentingEditView) {
        NavigationView {
          let rec = currentRecord!
          
          VStack {
            MbaRecordFormView(type: currentType, value: rec.value, notes: rec.notes ?? "", saveAction: { value, notes in

              currentRecord?.value = value
              currentRecord?.notes = notes

              try? dataController.container.viewContext.save()
              isPresentingEditView = false
              currentRecord = nil
              updated = "\(NSDate().timeIntervalSince1970)"
            })
            Spacer()
          }
          
          
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(rec.dateFormatted)
          .toolbar {
            ToolbarItem(placement: .cancellationAction) {
              Button("Cancel") {
                isPresentingEditView = false
                currentRecord = nil
              }
            }
          }
        }
        
        
//        if (currentRecord != nil) {
//
//
          
//            .toolbar {
//              ToolbarItem(placement: .cancellationAction) {
//                  Button("Cancel") {
//                    isPresentingEditView = false
//                    currentRecord = nil
//                  }
//              }
//            }
//        }
        
        
//        MbaRecordFormView(type: currentType, saveAction: { value, notes in
//
//        }, value: rec.value, notes: rec.notes) {
//
//        }
        
//        MbaRecordFormView(type: currentType, value: currentRecord!.value, notes: currentRecord!.notes) { value, notes in
//          let newRecord = MbaRecord(context: dataController.container.viewContext)
//          newRecord.id    = UUID()
//          newRecord.type  = currentType
//          newRecord.date  = date
//          newRecord.value = value
//          newRecord.notes = notes
//
//          try? dataController.container.viewContext.save()
//          updated = "\(NSDate().timeIntervalSince1970)"
//        }
        
      }
  }
  
  
  /// Handle the delete action
  /// - Parameter offsets: The index of the item in the data set
  func delete(at offsets: IndexSet) {
    let records = dataController.getRecordsForDateByType(for: date, by:currentType)
    
    let idsToDelete = offsets.map { $0 }
    
    for index in idsToDelete {
      let record = records[index]
      dataController.container.viewContext.delete(record)
    }
    
    try? dataController.container.viewContext.save()
    updated = "\(NSDate().timeIntervalSince1970)"
  }
}

struct MyDayView_Previews: PreviewProvider {
  static var previews: some View {
    let dataController = DataController(inMemory: true)
    TestData.generateTestData(dataController: dataController)
    
    return MyDayView(date: Date.now, dataController: dataController)
  }
}
