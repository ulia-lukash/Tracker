//
//  WeekDays.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation

enum WeekDays: Int, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

class DaysValue: NSObject, Codable {
    let schedule: Set<WeekDays>
    
    init(schedule: Set<WeekDays>) {
        self.schedule = schedule
        super.init()
    }
}

@objc
final class DaysValueTransformer: ValueTransformer {
    // тут будем писать код транформации
    
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? DaysValue else { return nil }
        return try? JSONEncoder().encode(days)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode(DaysValue.self, from: data as Data)
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}
