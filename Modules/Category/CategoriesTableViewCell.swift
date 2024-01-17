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
    var viewModel: SetCategoryViewModel?
    
    // MARK: - Private Properties
    
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(indexPath: IndexPath) {
        selectionStyle = .none
        textLabel?.text = viewModel?.categories[indexPath.row].name
        
        if viewModel?.categoriesNumber() ==  1 {
            if indexPath.row == 0 {
                separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                layer.cornerRadius = 16
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        } else if (viewModel?.categoriesNumber())! > 1 {
            if indexPath.row == (viewModel?.categoriesNumber())! - 1 {
                layer.cornerRadius = 16
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                layer.cornerRadius = 0
            }
        }
    }
    // MARK: - Private Methods

    private func setup() {
        detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        detailTextLabel?.textColor = UIColor(named: "Gray")
        heightAnchor.constraint(equalToConstant: 75).isActive = true
        backgroundColor = UIColor(named: "Background")
        
    }
    
}
