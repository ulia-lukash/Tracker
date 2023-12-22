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
        var tracker = Tracker(id: id, name: name, colour: colour, emoji: emoji, schedule: schedule)
 
        return tracker
    }
    
    func saveTrackerCoreData(_ tracker: Tracker, toCategory category: TrackerCategory) {
        let newTracker = TrackerCoreData(context: context)
        
        newTracker.id = tracker.id
        newTracker.name = tracker.name
        newTracker.emoji = tracker.emoji
        newTracker.colour = tracker.colour.name
        if let schedule = tracker.schedule {
            newTracker.schedule = DaysValue(schedule: schedule)
        }
        let fetchedCategory = categoryStore.fetchCategoryWithId(category.id)
        newTracker.category = fetchedCategory
                
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
    
    func fetchTrackerWithId(_ id: UUID) -> TrackerCoreData {
            let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        
            request.returnsObjectsAsFaults = false
        let uuid = id.uuidString

        request.predicate = NSPredicate(format: "id == %@", uuid)
            let tracker = try! context.fetch(request)

            return tracker[0]

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
}
