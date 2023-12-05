//
//  SettingOptions.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation

struct SettingOptions {
    let name: String
    // - TODO: Отображение категории/расписания после выбора...
    let pickedParameter: Any?
    let handler: () -> Void
}
