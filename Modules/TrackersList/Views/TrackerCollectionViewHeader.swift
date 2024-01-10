//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

class TrackerCollectionViewHeader: UICollectionReusableView {
    
    // MARK: - Public Properties
    
    static let identifier = "header"
    
    // MARK: - Private Properties
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(model: TrackerCategory) {
        titleLabel.text = model.name
    }
    
    // MARK: - Private Methods
    
    private func makeViewLayout() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
}
