//
//  MbaRecordFormView.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import SwiftUI

struct MbaRecordFormView: View {
  var type: String
  @State private var value: Double = 0
  @State private var notes: String = ""
  
  let saveAction: (Double, String) -> Void
  
  init(type: String, saveAction: @escaping (Double, String) -> Void) {
    self.type = type
    self.saveAction = saveAction
  }
  
  init(type: String, value: Double, notes: String, saveAction: @escaping (Double, String) -> Void) {
    self.type = type
    self.value = value
    self.notes = notes
    self.saveAction = saveAction
  }
  
  var body: some View {
    VStack {
      Picker("Please choose", selection: $value) {
        ForEach(MbaRecord.getOptionsForType(recordType: type), id: \.self) {
          Text("\(MbaRecord.formatValue(recordType: type, value: $0))")
        }
      }
      .pickerStyle(.wheel)
      
      TextEditor(text: $notes)
        .frame(height: 100)
        .border(.gray)
      
      Section {
        VStack(alignment: .center) {
          Button("Add") {
            print("Vls \(value)")
            print("Nts \(notes)")
            saveAction(value, notes)
          }
        }
        .padding(.top)
        .padding(.bottom)
        .frame(maxWidth: .infinity)
        .background(.blue)
        .foregroundColor(.white)
        .cornerRadius(8)
        
      }
      .padding(.top)
    }
  }
}

struct MbaRecordFormView_Previews: PreviewProvider {
  static var previews: some View {
    return MbaRecordFormView(type: "pain") { value, notes in
      //
    }
  }
}
