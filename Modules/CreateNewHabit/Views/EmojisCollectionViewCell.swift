//
//  EmojisTableViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 06.12.2023.
//

import Foundation
import UIKit

class EmojisCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "emojisTableCell"
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
       NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
