//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation

// - сущность для хранения трекеров по категориям
struct TrackerCategory {
    
    let id: UUID
    let name: String
    var trackers: [Tracker]
}
