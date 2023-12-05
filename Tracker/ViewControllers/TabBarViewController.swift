//
//  TabBarViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTabBarItems()
    }
    
    private func setupTabBarItems() {
        let trackerController = UINavigationController(rootViewController: TrackersViewController())
        let statisticController = UINavigationController(rootViewController: StatisticsViewController())
        
        trackerController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle.fill"),
            tag: 0
        )
        statisticController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(systemName: "hare.fill"),
            tag: 1
        )

        viewControllers = [trackerController, statisticController]
    }
}
