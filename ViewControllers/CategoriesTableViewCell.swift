//
//  CategoriesTableViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 07.12.2023.
//

import Foundation
import UIKit

final class CategoriesTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "CategoriesTableViewCell"

    // MARK: - Private Properties
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = UIColor(named: "Gray")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    

    // MARK: - Private Methods

}
