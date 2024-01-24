//
//  TrackerCoreData+CoreDataProperties.swift
//  Tracker
//
//  Created by Uliana Lukash on 24.01.2024.
//
//

import Foundation
import CoreData


extension TrackerCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
        return NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    }

    @NSManaged public var colour: String?
    @NSManaged public var emoji: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isPinned: Bool
    @NSManaged public var name: String?
    @NSManaged var schedule: DaysValue?
    @NSManaged public var category: TrackerCategoryCoreData?

}

extension TrackerCoreData : Identifiable {

}
