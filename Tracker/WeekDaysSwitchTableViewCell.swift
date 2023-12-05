//
//  WeekDaysSwitchTableViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation
import UIKit

protocol WeekDaysSwitchTableViewCellDelegate: AnyObject {
    func didChangeState(isOn: Bool, for weekDay: WeekDays)
}

final class WeekDaysSwitchTableViewCell: UITableViewCell {
    
    static let identifier = "WeekDaysSwitchTableViewCell"
    
    private var weekDay: WeekDays?
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 17, weight: .regular)
        
        return label
    }()
    
    private lazy var switchControl: UISwitch = {
        let mySwitch = UISwitch()
        
        mySwitch.onTintColor = UIColor(red: 0.22, green: 0.45, blue: 0.91, alpha: 1)
        mySwitch.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
        
        return mySwitch
    }()
    
        weak var delegate: WeekDaysSwitchTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(options: SwitchOptions) {
        weekDay = options.weekDay
        nameLabel.text = options.name
        switchControl.isOn = options.isOn
    }
    
    @objc private func didToggleSwitch() {
        guard let weekDay = weekDay else {
            return
        }
        delegate?.didChangeState(isOn: switchControl.isOn, for: weekDay)
    }
    
    private func configView() {
        contentView.backgroundColor = UIColor(named: "Background [day]")
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(switchControl)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            switchControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}


enum WeekDays: Int {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
}

struct SwitchOptions {
    let weekDay: WeekDays
    let name: String
    let isOn: Bool
}
