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
    
    lazy var accessoryImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = UIColor(named: "Gray")
        makeViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    

    // MARK: - Private Methods
    
    private func makeViewLayout() {
        
        contentView.backgroundColor = UIColor(named: "Background")
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(accessoryImage)
        
        accessoryImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            accessoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            accessoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
    }
}
