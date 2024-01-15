//
//  SettingTableViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import UIKit

final class SettingTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "SettingTableViewCell"
    
    // MARK: - Private Properties
    
    private lazy var accessoryImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Chevron"))
        
        return image
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
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
