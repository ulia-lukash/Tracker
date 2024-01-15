//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - UIViewController(*)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBarItems()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBarItems() {
        let trackerController = UINavigationController(rootViewController: TrackersViewController())
        let statisticController = UINavigationController(rootViewController: StatisticsViewController())
        
        trackerController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Trackers", comment: ""),
            image: UIImage(systemName: "record.circle.fill"),
            tag: 0
        )
        statisticController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Stats", comment: ""),
            image: UIImage(systemName: "hare.fill"),
            tag: 1
        )
        
        viewControllers = [trackerController, statisticController]
    }
}
