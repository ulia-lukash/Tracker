//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Uliana Lukash on 17.01.2024.
//

import Foundation
import YandexMobileMetrica

final class AnalyticsService {
    static let shared = AnalyticsService()
    
    func addTrackerButtonTapped() {
        YMMYandexMetrica.reportEvent("Add tracker button tapped on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didSelectDate() {
        YMMYandexMetrica.reportEvent("Date picker date changed on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didAttemptSearching() {
        YMMYandexMetrica.reportEvent("Attempted searching for trackers on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didAttemptDeletingTracker() {
        YMMYandexMetrica.reportEvent("Tried deleting a tracker on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didDeleteTracker() {
        YMMYandexMetrica.reportEvent("Confirmed tracker deletion on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didCancelTrackerDeletion() {
        YMMYandexMetrica.reportEvent("Canceled tracker deletion on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didPressEditTracker() {
        YMMYandexMetrica.reportEvent("Moved from TrackersViewController to Edit tracker page", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didPinTracker() {
        YMMYandexMetrica.reportEvent("Pinned of unpinned tracker on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didCompleteTracker() {
        YMMYandexMetrica.reportEvent("Marked tracker completed on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didUndoCompleteTracker() {
        YMMYandexMetrica.reportEvent("Marked tracker not completed on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didOpenFiltersMenu() {
        YMMYandexMetrica.reportEvent("Did press the filters button on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

