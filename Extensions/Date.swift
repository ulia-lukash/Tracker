//
//  Date.swift
//  Tracker
//
//  Created by Uliana Lukash on 18.01.2024.
//

import Foundation

extension Date {
    func weekDayNumber() -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let weekDay = calendar.component(.weekday, from: self)
        let daysWeek = 7
        return (weekDay - calendar.firstWeekday + daysWeek) % daysWeek + 1
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func omitTime() -> Date? {
        let calendarDateComponents = Calendar.current.dateComponents([.day, .year, .month], from: self)
        return Calendar.current.date(from: calendarDateComponents)
    }
}
