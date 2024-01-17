//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Uliana Lukash on 17.01.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let vc = TrackersViewController()
        
        assertSnapshot(matching: vc, as: .image)
    }
    
}
