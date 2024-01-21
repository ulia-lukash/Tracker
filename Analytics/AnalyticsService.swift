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
    
    ///Property to use the service in other classes.
    static let shared = AnalyticsService()
    
    ///Sends a report when TrackersViewController is opened
    func didOpenViewController() {
        YMMYandexMetrica.reportEvent("Opened TrackersViewController", parameters: ["event": "open", "screen": "Main"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when TrackersViewController is closed.
    func didCloseViewController() {
        YMMYandexMetrica.reportEvent("Closed TrackersViewController", parameters: ["event": "close", "screen": "Main"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    /// Sends a report when user taps the add button on main vc (TrackersViewController).
    func addTrackerButtonTapped() {
        YMMYandexMetrica.reportEvent("Add tracker button tapped on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "add_track"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    /// Sends report when used taps tracker
    func didTapTracker() {
        YMMYandexMetrica.reportEvent("Did tap one tracker on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "tracker"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Send a report when user presses the filters button.
    func didOpenFiltersMenu() {
        YMMYandexMetrica.reportEvent("Did press the filters button on TrackersViewController", parameters: ["event": "click", "screen": "Main", "item": "filter"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user chooses the edit option of one tracker's context menu.
    func didPressEditTracker() {
        YMMYandexMetrica.reportEvent("Chose edit option in tracker's context menu", parameters: ["event": "click", "screen": "main", "item": "edit"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user chooses the delete option of one tracker's context menu.
    func didPressDeleteTracker() {
        YMMYandexMetrica.reportEvent("Chose delete option in tracker's context menu", parameters: ["event": "click", "screen": "main", "item": "delete"], onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    /// Sends a report when user changes datePicker's date on main vc (TrackersViewController).
    func didSelectDate() {
        YMMYandexMetrica.reportEvent("Date picker date changed on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    ///Sends a report when user interacts with the search filed on main vc (TrackersViewController). Tracks all actions inside the searchfield (each inputted symbol will trigger it's own action for this metrica)
    func didAttemptSearching() {
        YMMYandexMetrica.reportEvent("Attempted searching for trackers on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user confirms their decision to delete tracker in the alert window.
    func didDeleteTracker() {
        YMMYandexMetrica.reportEvent("Confirmed tracker deletion on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user cancels their decision to delete tracker.
    func didCancelTrackerDeletion() {
        YMMYandexMetrica.reportEvent("Canceled tracker deletion on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user chooses the pin/unpin option of one tracker's context menu.
    func didPinTracker() {
        YMMYandexMetrica.reportEvent("Pinned or unpinned tracker on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user marks tracker comleted.
    func didCompleteTracker() {
        YMMYandexMetrica.reportEvent("Marked tracker completed on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    ///Sends a report when user marks tracker not completed.
    func didUndoCompleteTracker() {
        YMMYandexMetrica.reportEvent("Marked tracker not completed on TrackersViewController", parameters: nil, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    
    
    
}

