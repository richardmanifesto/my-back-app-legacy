//
//  DataController.swift
//  mba
//
//  Created by Richard Hanson on 02/04/2022.
//

import CoreData
import Foundation

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "MbaData")
  
  init(inMemory: Bool = false) {
    if inMemory {
      container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
  
  func getRecordsForDate(for date: Date) -> [MbaRecord] {
    let fetchRequest = NSFetchRequest<MbaRecord>(entityName: "MbaRecord")
    let startDate    = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date.now)!
    let endDate      = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date.now)!
    
    let predicate = NSPredicate(format: "date > %@ AND date < %@", startDate as NSDate, endDate as NSDate)
    fetchRequest.predicate = predicate
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    var fetchedRecords = [MbaRecord]()
    
    do {
      fetchedRecords = try container.viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to fetch employees: \(error)")
    }
    
    return fetchedRecords
  }
  
  func getRecordsForDateByType(for date: Date, by type: String) -> [MbaRecord] {
    let fetchRequest = NSFetchRequest<MbaRecord>(entityName: "MbaRecord")
    let startDate    = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date.now)!
    let endDate      = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date.now)!
    
    let predicate = NSPredicate(format: "date > %@ AND date < %@ AND type == %@", startDate as NSDate, endDate as NSDate, type)
    fetchRequest.predicate = predicate
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    var fetchedRecords = [MbaRecord]()
    
    do {
      fetchedRecords = try container.viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to fetch employees: \(error)")
    }
    
    return fetchedRecords
  }
  
  func getRecordsForLastSevenDaysByType(for date: Date, by type: String) -> [MbaRecord] {
    let fetchRequest = NSFetchRequest<MbaRecord>(entityName: "MbaRecord")
    let startDate    = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
    var dayComponent = DateComponents()
    dayComponent.day = -7
    let endDate      = Calendar.current.date(byAdding: dayComponent, to: date)!
    
    print("endDate", endDate)
    
//    let predicate = NSPredicate(format: "date > %@ AND date < %@ AND type == %@", startDate as NSDate, endDate as NSDate, type)
    
    let predicate = NSPredicate(format: "date > %@ AND type == %@", endDate as NSDate, type)
    fetchRequest.predicate = predicate
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    var fetchedRecords = [MbaRecord]()
    
    do {
      fetchedRecords = try container.viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to get records: \(error)")
    }
    
    return fetchedRecords
  }
  
  func getRecordsForLastMonthByType(for date: Date, by type: String) -> [MbaRecord] {
    let fetchRequest = NSFetchRequest<MbaRecord>(entityName: "MbaRecord")
    let startDate    = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
    var dayComponent = DateComponents()
    dayComponent.day = -28
    let endDate      = Calendar.current.date(byAdding: dayComponent, to: date)!
    
    print("endDate", endDate)
    
//    let predicate = NSPredicate(format: "date > %@ AND date < %@ AND type == %@", startDate as NSDate, endDate as NSDate, type)
    
    let predicate = NSPredicate(format: "date > %@ AND type == %@", endDate as NSDate, type)
    fetchRequest.predicate = predicate
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    var fetchedRecords = [MbaRecord]()
    
    do {
      fetchedRecords = try container.viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to get records: \(error)")
    }
    
    return fetchedRecords
  }
  
  func getRecordsForLastThreeMonthsByType(for date: Date, by type: String) -> [MbaRecord] {
    let fetchRequest = NSFetchRequest<MbaRecord>(entityName: "MbaRecord")
    let startDate    = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
    
    var dayComponent = DateComponents()
    dayComponent.day = -28 * 3
    let endDate      = Calendar.current.date(byAdding: dayComponent, to: date)!
    
    print("endDate", endDate)
    
//    let predicate = NSPredicate(format: "date > %@ AND date < %@ AND type == %@", startDate as NSDate, endDate as NSDate, type)
    
    let predicate = NSPredicate(format: "date > %@ AND type == %@", endDate as NSDate, type)
    fetchRequest.predicate = predicate
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    
    var fetchedRecords = [MbaRecord]()
    
    do {
      fetchedRecords = try container.viewContext.fetch(fetchRequest)
    } catch {
      print("Failed to get records: \(error)")
    }
    
    return fetchedRecords
  }
}
