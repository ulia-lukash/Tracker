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
    
    func getCategories() -> [TrackerCategory] {
        return transformCoredataCategories(fetchCoreDataCategories())
    }
    private func transformCoredataCategories(_ categories: [TrackerCategoryCoreData]) -> [TrackerCategory] {
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
                let newTracker = Tracker(id: id, name: name, colour: colour, emoji: emoji, schedule: schedule)
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
    func addMockDataToCoreData() {
        
        let firstCategory = TrackerCategoryCoreData(context: context)
        firstCategory.id = UUID()
        firstCategory.name = "Home"
        let firstTracker = TrackerCoreData(context: context)
        firstTracker.id = UUID()
        firstTracker.name = "Cleaning"
        firstTracker.emoji = "🌺"
        firstTracker.colour = "Color selection 13"
        let secondTracker = TrackerCoreData(context: context)
        secondTracker.id = UUID()
        secondTracker.name = "Cooking"
        secondTracker.emoji = "🌺"
        secondTracker.colour = "Color selection 7"
        firstCategory.trackers = [firstTracker, secondTracker]
        
        let secondCategory = TrackerCategoryCoreData(context: context)
        secondCategory.id = UUID()
        secondCategory.name = "Fun"
        let firsTracker = TrackerCoreData(context: context)
        firsTracker.id = UUID()
        firsTracker.name = "Funning"
        firsTracker.emoji = "🌺"
        firsTracker.colour = "Color selection 11"
        let secndTracker = TrackerCoreData(context: context)
        secndTracker.id = UUID()
        secndTracker.name = "Unfunning"
        secndTracker.emoji = "🌺"
        secndTracker.colour = "Color selection 15"
        secondCategory.trackers = [firsTracker, secndTracker]
        
        do {
            try self.context.save()
        }
        catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
    }
    
    func isCategoryInCoreData(_ category: TrackerCategory) -> Bool {
        var categories: [TrackerCategoryCoreData] = []
        do {
            categories = try context.fetch(TrackerCategoryCoreData.fetchRequest())
        }
        catch {
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
}
