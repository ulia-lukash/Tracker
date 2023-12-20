//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation

// - сущность для хранения записи о том, что некий трекер был выполнен на некоторую дату
struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}
