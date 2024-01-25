//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Uliana Lukash on 24.01.2024.
//

import XCTest
import SnapshotTesting

@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackersViewController()
        assertSnapshot(matching: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)))
    }
    
    func testViewCOntrollerDarkTheme() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)))
    }
}
