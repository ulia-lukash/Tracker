//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Uliana Lukash on 12.12.2023.
//

import Foundation
import CoreData
import UIKit


final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var coreDataCategories: [ TrackerCategoryCoreData ]?
    
    var catsAtt: [TrackerCategory] = []
    
    func getCategories()  -> [TrackerCategory] {
        return  transformCoredataCategories(fetchCoreDataCategories())
    }
    
    func transformCoreDatacategory(_ category: TrackerCategoryCoreData) -> TrackerCategory {
        let id = category.id!
        let name = category.name!
        var trackers: [Tracker] = []
        let alltrackers = category.trackers?.allObjects as! [TrackerCoreData]
        for tracker in alltrackers {
            if let id = tracker.id, let name = tracker.name, let emoji = tracker.emoji, let colour = UIColor(named: tracker.colour!), let schedule = tracker.schedule?.schedule  {
                let isPinned = tracker.isPinned
                let newTracker = Tracker(id: id, name: name, colour: colour, emoji: emoji, schedule: schedule, isPinned: isPinned)
                trackers.append(newTracker)
            }
            
        }
        return TrackerCategory(id: id, name: name, trackers: trackers)
    }
    
    func transformCoredataCategories(_ categories: [TrackerCategoryCoreData]) -> [TrackerCategory] {
        var cats: [TrackerCategory] = []
        for category in categories {
            let id = category.id!
            let name = category.name!
            var trackers: [Tracker] = []
            let alltrackers = category.trackers?.allObjects as? [TrackerCoreData]
            for tracker in alltrackers! {
                let id = tracker.id!
                let name = tracker.name!
                let emoji = tracker.emoji!
                let colour = UIColor(named: tracker.colour!)!
                let schedule = tracker.schedule?.schedule
                let isPinned = tracker.isPinned
                let newTracker = Tracker(id: id, name: name, colour: colour, emoji: emoji, schedule: schedule, isPinned: isPinned)
                trackers.append(newTracker)
            }
            let newCategory = TrackerCategory(id: id, name: name, trackers: trackers)
            cats.append(newCategory)
        }
        return cats
    }
    
    private func fetchCoreDataCategories() -> [TrackerCategoryCoreData]  {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        }
        
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return categories
    }
    
    func saveCategoryToCoreData(_ category: TrackerCategory) {
        
        if !isCategoryInCoreData(category) {
            
            let newCategory = TrackerCategoryCoreData(context: context)
            
            newCategory.id = category.id
            newCategory.name = category.name
            
            do {
                try self.context.save()
            }
            catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func isCategoryInCoreData(_ category: TrackerCategory) -> Bool {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        if categories.contains(where: { $0.id == category.id}) {
            return true
        } else {
            return false
        }
    }
    func fetchCategoryWithId(_ id: UUID) -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.returnsObjectsAsFaults = false
        let uuid = id.uuidString
        
        request.predicate = NSPredicate(format: "id == %@", uuid)
        let category = try! context.fetch(request)
        
        return category[0]
        
    }
    func fetchCategoryWithName(_ name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        
        request.returnsObjectsAsFaults = false
        
        request.predicate = NSPredicate(format: "name == %@", name)
        let category = try! context.fetch(request)
        
        if category.count > 0 {
            return category[0]
        } else {
            return nil
        }
        
    }
    
    func renameCategory(_ id: UUID, newName: String) {
        let category = fetchCategoryWithId(id)
        category.name = newName
        
        do {
            try self.context.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteCategory(_ id: UUID) {
        let category = fetchCategoryWithId(id)
        
        if let trackers = category.trackers?.allObjects as? [TrackerCoreData] {
            for tracker in trackers {
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
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
                context.delete(tracker)

            }
        }
        context.delete(category)
        do {
            try context.save()
        } catch {
            
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
