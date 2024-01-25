//
//  ColoursCollectionViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 12.12.2023.
//

import Foundation
import UIKit

final class ColoursCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "coloursTableCell"
    
    var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 8
        
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                super.isSelected = true
                layer.masksToBounds = true
                layer.cornerRadius = 9.5
                layer.borderWidth = 3
                layer.borderColor = titleLabel.backgroundColor?.withAlphaComponent(0.3).cgColor
            }
            else
            {
                super.isSelected = false
                layer.borderColor = UIColor(named: "White")?.cgColor
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func pickCell(withColour colour: CGColor) {
        layer.masksToBounds = true
        layer.cornerRadius = 9.5
        layer.borderWidth = 3
        layer.borderColor = colour
    }
}
