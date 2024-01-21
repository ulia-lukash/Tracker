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
            records = try context.fetch(request)
        }
        catch {
            
        }
        return records
    }
    
    func fetchCompletedRecordsForTracker(_ tracker: TrackerCoreData) -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "tracker == %@", tracker)
        do {
            records = try context.fetch(request)
        }
        catch {
            
        }
        return records
    }
    
    func deleteCompletedRecordsForTracker(_ tracker: TrackerCoreData) {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "tracker == %@", tracker)
        do {
            records = try context.fetch(request)
            for record in records {
                context.delete(record)
                do {
                    try self.context.save()
                }
                catch {
                    
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
        catch {
            
        }
    }
    
    private func fetchCompletedRecords() -> [TrackerRecordCoreData] {
        var records: [TrackerRecordCoreData] = []
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        
        do {
            records = try context.fetch(request)
        }
        catch {
            
        }
        return records
    }
    
    func getNumberOfCompletedTrackers() -> Int {
        fetchCompletedRecords().count
    }
    
    private func convertToTrackerRecord(coreDataRecords: [TrackerRecordCoreData]) -> [TrackerRecord] {
        
        var trackerRecords: [TrackerRecord] = []
        for trackerRecord in coreDataRecords {
            let date = trackerRecord.date!
            let tracker = trackerStore.convertToTracker(coreDataTracker: trackerStore.fetchTrackerWithId(trackerRecord.trackerId!))
            let newRecord = TrackerRecord(trackerId: tracker.id, date: date)
            trackerRecords.append(newRecord)
        }
        return trackerRecords
    }
    
    func saveTrackerRecordCoreData(_ trackerRecord: TrackerRecord) {
        
        let newTrackerRecord = TrackerRecordCoreData(context: context)
        newTrackerRecord.date = trackerRecord.date
        
        newTrackerRecord.trackerId = trackerRecord.trackerId
        
        
        do {
            try self.context.save()
        }
        catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteTrackerRecord(with id: UUID, on date: Date) {
        
        let startOfDay = Calendar.current.startOfDay(for: date)
        let idString = id.uuidString
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "%K == %@ AND %K BETWEEN {%@, %@}",
                                        #keyPath(TrackerRecordCoreData.trackerId), idString,
                                        #keyPath(TrackerRecordCoreData.date), startOfDay as NSDate, Date() as NSDate)
        if let result = try? context.fetch(request) {
            for object in result {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func getStats() -> [Int]? {
        
        let keypathExp = NSExpression(forKeyPath: "date") // can be any column
        let expression = NSExpression(forFunction: "count:", arguments: [keypathExp])
        
        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType
        var perfectDays: Int = 0
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TrackerRecordCoreData")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["date"]
        request.propertiesToFetch = ["date", countDesc]
        request.resultType = .dictionaryResultType
        
        let trackerRecords = try! context.execute(request) as! NSAsynchronousFetchResult<NSFetchRequestResult>
        guard let records = trackerRecords.finalResult else { return nil }
        let recordsDict = records as! [[String: Any]]

        var dates: [Date] = []
        
        let defaults = UserDefaults.standard
        for record in recordsDict {
            dates.append(record["date"] as! Date)
            let weekday: Date = record["date"] as! Date
            let number = weekday.weekDayNumber()
            switch number {
            case 1:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnMonday") {
                    perfectDays += 1
                }
                break
            case 2:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnTuesday") {
                    perfectDays += 1
                }
                break
            case 3:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnWednesday") {
                    perfectDays += 1
                }
                break
            case 4:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnThursday") {
                    perfectDays += 1
                }
                break
            case 5:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnFriday") {
                    perfectDays += 1
                }
                break
            case 6:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnSaturday") {
                    perfectDays += 1
                }
                break
            case 7:
                if record["count"] as! Int == defaults.integer(forKey: "TrackersOnSunday") {
                    perfectDays += 1
                }
                break
            default:
                break
            }
        }
        
        let bestPeriod = checkStreak(of: dates)
        let average = getNumberOfCompletedTrackers()/recordsDict.count
        
//        print(average)
        return([perfectDays, average, bestPeriod])
    }
    
    func checkStreak(of dateArray: [Date]) -> Int{
    let dates = dateArray.sorted()
    // Check if the array contains more than 0 dates, otherwise return 0
    guard dates.count > 0 else { return 0 }
    // Get full day value of first date in array
    let referenceDate = Calendar.current.startOfDay(for: dates.first!)
    // Get an array of (non-decreasing) integers
    let dayDiffs = dates.map { (date) -> Int in
            Calendar.current.dateComponents([.day], from: referenceDate, to: date).day!
        }
    // Return max streak
    return maximalConsecutiveNumbers(in: dayDiffs)
    }
    // Find maximal length of a subsequence of consecutive numbers in the array.
    // It is assumed that the array is sorted in non-decreasing order.
    // Consecutive equal elements are ignored.
    func maximalConsecutiveNumbers(in array: [Int]) -> Int{
    var longest = 0 // length of longest subsequence of consecutive numbers
    var current = 1 // length of current subsequence of consecutive numbers
    for (prev, next) in zip(array, array.dropFirst()) {
    if next > prev + 1 {
    // Numbers are not consecutive, start a new subsequence.
                current = 1
            } else if next == prev + 1 {
    // Numbers are consecutive, increase current length
                current += 1
            }
    if current > longest {
                longest = current
            }
        }
    return longest
    }
}
