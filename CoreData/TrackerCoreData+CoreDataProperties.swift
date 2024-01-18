//
//  TrackerCoreData+CoreDataProperties.swift
//  
//
//  Created by Uliana Lukash on 18.01.2024.
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
    @NSManaged public var name: String?
    @NSManaged var schedule: DaysValue?
    @NSManaged public var isPinned: Bool
    @NSManaged public var category: TrackerCategoryCoreData?
    @NSManaged public var trackerRecords: NSSet?

}

// MARK: Generated accessors for trackerRecords
extension TrackerCoreData {

    @objc(addTrackerRecordsObject:)
    @NSManaged public func addToTrackerRecords(_ value: TrackerRecordCoreData)

    @objc(removeTrackerRecordsObject:)
    @NSManaged public func removeFromTrackerRecords(_ value: TrackerRecordCoreData)

    @objc(addTrackerRecords:)
    @NSManaged public func addToTrackerRecords(_ values: NSSet)

    @objc(removeTrackerRecords:)
    @NSManaged public func removeFromTrackerRecords(_ values: NSSet)

}

extension TrackerCoreData: Identifiable {
    
}
