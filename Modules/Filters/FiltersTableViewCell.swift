//
//  FiltersTableViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 17.01.2024.
//

import Foundation
import UIKit

final class FiltersTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "FiltersTableViewCell"
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                super.isSelected = true
                self.accessoryType = .checkmark
            }
            else
            {
                super.isSelected = false
                self.accessoryType = .none
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setUp() {
        heightAnchor.constraint(equalToConstant: 75).isActive = true
        backgroundColor = UIColor(named: "Background")
    }
}
