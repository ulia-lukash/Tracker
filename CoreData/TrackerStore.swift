//
//  TrackerStore.swift
//  Tracker
//
//  Created by Uliana Lukash on 12.12.2023.
//

import Foundation
import CoreData
import UIKit

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    let categoryStore = TrackerCategoryStore.shared
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func convertToTracker(coreDataTracker: TrackerCoreData) -> Tracker {
        let id = coreDataTracker.id!
        let name = coreDataTracker.name!
        let colour = UIColor(named: coreDataTracker.colour!)!
        let emoji = coreDataTracker.emoji!
        let schedule = coreDataTracker.schedule?.schedule
        let isPinned = coreDataTracker.isPinned
        var tracker = Tracker(id: id, name: name, colour: colour, emoji: emoji, schedule: schedule, isPinned: isPinned)
        
        return tracker
    }
    
    func saveTrackerCoreData(_ tracker: Tracker, toCategory category: TrackerCategory) {
        let newTracker = TrackerCoreData(context: context)
        
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.colour = tracker.colour.name
        newTracker.isPinned = false
        if let schedule = tracker.schedule {
            newTracker.schedule = DaysValue(schedule: schedule)
        }
        let fetchedCategory = categoryStore.fetchCategoryWithId(category.id)
        newTracker.category = fetchedCategory
        
        do {
            try self.context.save()
        }
        catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func editTracker(withId id: UUID, tracker: Tracker, category: TrackerCategory) {
        let trackerCoreData = fetchTrackerWithId(id)
        
        let defaults = UserDefaults.standard
        
        let previousSchedule = trackerCoreData.schedule?.schedule
        
        /**Remove previously scheduled days**/
        for day in previousSchedule! {
            switch day {
            case .monday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnMonday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnMonday")
            case .tuesday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnTuesday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnTuesday")
            case .wednesday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnWednesday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnWednesday")
            case .thursday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnThursday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnThursday")
            case .friday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnFriday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnFriday")
            case .saturday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnSaturday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnSaturday")
            case .sunday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnSunday") - 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnSunday")
            }
        }
        /**Add newly scheduled days*/
        for day in tracker.schedule! {
            switch day {
            case .monday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnMonday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnMonday")
            case .tuesday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnTuesday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnTuesday")
            case .wednesday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnWednesday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnWednesday")
            case .thursday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnThursday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnThursday")
            case .friday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnFriday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnFriday")
            case .saturday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnSaturday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnSaturday")
            case .sunday:
                let trackersOnMonday = defaults.integer(forKey: "TrackersOnSunday") + 1
                defaults.set(trackersOnMonday, forKey: "TrackersOnSunday")
            }
        }
        
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.colour = tracker.colour.name
        trackerCoreData.isPinned = tracker.isPinned
        trackerCoreData.schedule = DaysValue(schedule: tracker.schedule!)
        let fetchedCategory = categoryStore.fetchCategoryWithId(category.id)
        trackerCoreData.category = fetchedCategory
        
        do {
            try self.context.save()
        }
        catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchTrackerWithId(_ id: UUID) -> TrackerCoreData {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.returnsObjectsAsFaults = false
        let uuid = id.uuidString
        
        request.predicate = NSPredicate(format: "id == %@", uuid)
        let tracker = try! context.fetch(request)
        
        return tracker[0]
        
    }
    
    func fetchTrackersOfCategory(_ category: TrackerCategoryCoreData) -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "category == %@", category)
        let trackers = try! context.fetch(request)
        
        return trackers
    }
    
    private func fetchTrackers() -> [TrackerCoreData] {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
        request.returnsObjectsAsFaults = false
        
        let trackers = try! context.fetch(request)
        
        return trackers
        
    }
    
    func convertToTrackers(_ coreData: [TrackerCoreData]) -> [Tracker] {
        var trackers: [Tracker] = []
        for tracker in coreData {
            let converted = convertToTracker(coreDataTracker: tracker)
            trackers.append(converted)
        }
        return trackers
    }
    
    func getTrackers() -> [Tracker] {
        return convertToTrackers(fetchTrackers())
    }
    
    //    Существует возможно получать количество сразу из request...
    func getNumberOfTrackers() -> Int {
        let trackers = getTrackers()
        return trackers.count
    }
    
    func deleteTracker(withId id: UUID) {
        
        let tracker = fetchTrackerWithId(id)
        
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
        context.delete(tracker)
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
    }
    func pinTracker(withId id: UUID) {
        let tracker = fetchTrackerWithId(id)
        tracker.isPinned = !tracker.isPinned
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
