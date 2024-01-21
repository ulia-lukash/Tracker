//
//  NumberOfTrackersForWeakDay.swift
//  Tracker
//
//  Created by Uliana Lukash on 18.01.2024.
//

import Foundation

struct NumberOfTrackersForWeakDay: Codable {
    let monday: Int
    let tuesday: Int
    let wednesday: Int
    let thursday: Int
    let friday: Int
    let saturday: Int
    let sunday: Int
}

struct NumberOfCompletedPerDay: Codable {
    let numberOfCompletedTrackers: Int
    let dateOfCompletion: Date
    let dayOfWeek: Int
}
