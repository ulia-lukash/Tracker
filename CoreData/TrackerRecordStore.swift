//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Uliana Lukash on 12.12.2023.
//

import Foundation
import CoreData
import UIKit

// MARK: - Class

final class TrackerRecordStore {
   
    static let shared = TrackerRecordStore()
    let trackerStore = TrackerStore.shared
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getCompletedTrackers() -> [TrackerRecord] {
        return convertToTrackerRecord(coreDataRecords: fetchCompletedRecords())
    }
    private func fetchCompletedRecordsForDate(_ date: Date) -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        do {
            records = try! context.fetch(request)
        }
        catch {
            
        }
        return records
    }
    
    private func fetchCompletedRecords() -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            records = try! context.fetch(request)
        }
        catch {
            
        }
        return records
    }
    
    
    
    private func convertToTrackerRecord(coreDataRecords: [TrackerRecordCoreData]) -> [TrackerRecord] {
        
        var trackerRecords: [TrackerRecord] = []
        for trackerRecord in coreDataRecords {
            let date = trackerRecord.date!
            let tracker = trackerStore.convertToTracker(coreDataTracker: trackerRecord.tracker!)
            let newRecord = TrackerRecord(trackerId: tracker.id, date: date)
            trackerRecords.append(newRecord)
        }
        return trackerRecords
    }
    
    func saveTrackerRecordCoreData(_ trackerRecord: TrackerRecord) {
        
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.date = trackerRecord.date
        
        let tracker = trackerStore.fetchTrackerWithId(trackerRecord.trackerId)
        newTrackerRecord.tracker = tracker
        
                
        do {
            try self.context.save()
        }
        catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func deleteTrackerRecord(with id: UUID, on date: Date) {
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let trackerCoreData = trackerStore.fetchTrackerWithId(id)
        
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K BETWEEN {%@, %@}",
                                        #keyPath(TrackerRecordCoreData.tracker), trackerCoreData,
                                        #keyPath(TrackerRecordCoreData.date), startOfDay as NSDate, Date() as NSDate)
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
        }

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }




}
