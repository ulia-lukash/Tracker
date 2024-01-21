//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Types

    // MARK: - Constants

    // MARK: - Public Properties

    // MARK: - IBOutlet

    // MARK: - Private Properties
    
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
    // MARK: - Initializers

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        fetchStats()
    }
    // MARK: - Public Methods

    // MARK: - IBAction

    // MARK: - Private Methods
    private func setUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = NSLocalizedString("Stats", comment: "")
        
        view.addSubview(placeholderLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(bestPeriodLabel)
        view.addSubview(perfectDaysLabel)
        view.addSubview(completedTrackersLabel)
        view.addSubview(averageLabel)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        bestPeriodLabel.translatesAutoresizingMaskIntoConstraints = false
        perfectDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        completedTrackersLabel.translatesAutoresizingMaskIntoConstraints = false
        averageLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
                perfectDaysLabel.statsName = NSLocalizedString("Perfect days", comment: "")
                perfectDaysLabel.statsNumber = "\(perfectDays)"
    
                completedTrackersLabel.statsName = NSLocalizedString("Trackers completed", comment: "")
                completedTrackersLabel.statsNumber = "\(trackersCompleted)"
                
                let average = stats[1]
                
                averageLabel.statsName = NSLocalizedString("Average value", comment: "")
                averageLabel.statsNumber = "\(average)"
                
                let bestPeriod = stats[2]
                
                bestPeriodLabel.statsNumber = "\(bestPeriod)"
                bestPeriodLabel.statsName = NSLocalizedString("Best period", comment: "")
            }
            
        }
    }
}
