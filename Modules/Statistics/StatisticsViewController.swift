//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

final class StatisticsViewController: UIViewController {
        
    private let recordStore = TrackerRecordStore.shared
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("There is nothing to analyze", comment: "")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "statistics_placeholder")
        return imageView
    }()
    
    private lazy var bestPeriodLabel = CustomView()
    private lazy var perfectDaysLabel = CustomView()
    private lazy var completedTrackersLabel = CustomView()
    private lazy var averageLabel = CustomView()

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
                
        fetchStats()
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchStats()
    }
    
    // MARK: - Private Methods
  
    private func setUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = NSLocalizedString("Stats", comment: "")
        [placeholderLabel, placeholderImageView, bestPeriodLabel, perfectDaysLabel, completedTrackersLabel, averageLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            bestPeriodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bestPeriodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bestPeriodLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -198),
            bestPeriodLabel.heightAnchor.constraint(equalToConstant: 90),
            perfectDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            perfectDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            perfectDaysLabel.topAnchor.constraint(equalTo: bestPeriodLabel.bottomAnchor, constant: 12),
            perfectDaysLabel.heightAnchor.constraint(equalToConstant: 90),
            completedTrackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedTrackersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedTrackersLabel.topAnchor.constraint(equalTo: perfectDaysLabel.bottomAnchor, constant: 12),
            completedTrackersLabel.heightAnchor.constraint(equalToConstant: 90),
            averageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            averageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            averageLabel.topAnchor.constraint(equalTo: completedTrackersLabel.bottomAnchor, constant: 12),
            averageLabel.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    private func showPlaceholder() {
        placeholderLabel.isHidden = false
        placeholderImageView.isHidden = false
        bestPeriodLabel.isHidden = true
        perfectDaysLabel.isHidden = true
        completedTrackersLabel.isHidden = true
        averageLabel.isHidden = true
    }
    
    private func hidePlaceholder() {
        placeholderLabel.isHidden = true
        placeholderImageView.isHidden = true
        bestPeriodLabel.isHidden = false
        perfectDaysLabel.isHidden = false
        completedTrackersLabel.isHidden = false
        averageLabel.isHidden = false
    }
    
    private func fetchStats() {
        let trackersCompleted = recordStore.getNumberOfCompletedTrackers()
        if trackersCompleted == 0 {
            showPlaceholder()
            return
        } else {
            if let stats = recordStore.getStats() {
                hidePlaceholder()
                let perfectDays = stats[0]
                perfectDaysLabel.updateView(number: "\(perfectDays)", name: NSLocalizedString("Perfect days", comment: ""))
                completedTrackersLabel.updateView(number: "\(trackersCompleted)", name: NSLocalizedString("Trackers completed", comment: ""))
                
                let average = stats[1]
                
                averageLabel.updateView(number: "\(average)", name: NSLocalizedString("Average value", comment: ""))
                
                let bestPeriod = stats[2]
                
                bestPeriodLabel.updateView(number: "\(bestPeriod)", name: NSLocalizedString("Best period", comment: ""))

            }
            
        }
    }
}
