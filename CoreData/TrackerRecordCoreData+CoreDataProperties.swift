//
//  TrackerRecordCoreData+CoreDataProperties.swift
//  
//
//  Created by Uliana Lukash on 23.01.2024.
//
//

import Foundation
import CoreData


extension TrackerRecordCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackerRecordCoreData> {
        return NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
    }

    @NSManaged public var date: Date?
    @NSManaged public var trackerId: UUID?

}
