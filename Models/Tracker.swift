//
//  Tracker.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

// - сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»)
struct Tracker {
    let id: UUID
    let name: String
    let colour: UIColor
    let emoji: String
    let schedule: Set<WeekDays>?
    let isPinned: Bool
}
