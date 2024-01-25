//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Uliana Lukash on 17.01.2024.
//

import Foundation
import YandexMobileMetrica

/// Used to send reports to Yandex AppMetrica
final class AnalyticsService {
    
    static let shared = AnalyticsService()
    
    func reportEvent(event: String, parameters: [String: String]) {
            YMMYandexMetrica.reportEvent(event, parameters: parameters, onFailure: { error in
                print("REPORT ERROR: %@", error.localizedDescription)
            })
        }

}

