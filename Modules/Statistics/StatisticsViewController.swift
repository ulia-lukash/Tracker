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
    
    // MARK: - Initializers

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    // MARK: - Public Methods

    // MARK: - IBAction

    // MARK: - Private Methods
    private func setUp() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = NSLocalizedString("Statistics", comment: "")
        
        view.addSubview(placeholderLabel)
        view.addSubview(placeholderImageView)
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func showPlaceholder() {
        placeholderLabel.isHidden = false
        placeholderImageView.isHidden = false
    }
    
    private func hidePlaceholder() {
        placeholderLabel.isHidden = true
        placeholderImageView.isHidden = true
    }
}
