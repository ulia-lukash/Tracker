//
//  SetScheduleViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation
import UIKit

protocol SetScheduleViewControllerDelegate: AnyObject {
    func didConfigure(schedule: Set<WeekDays>)
}

class SetScheduleViewController: UIViewController {
    
    weak var delegate: SetScheduleViewControllerDelegate?
    
    private var schedule: Set<WeekDays> = []
    private var switches: Array<SwitchOptions> = []
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Готово", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let weekDaysSwitchTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.register(WeekDaysSwitchTableViewCell.self, forCellReuseIdentifier: WeekDaysSwitchTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.heightAnchor.constraint(equalToConstant: 525).isActive = true
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        weekDaysSwitchTable.dataSource = self
        weekDaysSwitchTable.delegate = self
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        appendSwitches()
        configView()
        
    }
    
    private func configView() {
        view.addSubview(viewTitle)
        view.addSubview(doneButton)
        view.addSubview(weekDaysSwitchTable)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        weekDaysSwitchTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weekDaysSwitchTable.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            weekDaysSwitchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weekDaysSwitchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            doneButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func setDoneButtonState() {
        if schedule.isEmpty {
            doneButton.backgroundColor = UIColor(named: "Gray")
            doneButton.isEnabled = false
        } else {
            doneButton.backgroundColor = UIColor(named: "Black")
            doneButton.isEnabled = true
        }
    }
    
    private func appendSwitches() {
        switches.append(contentsOf: [
            SwitchOptions(weekDay: .monday, name: "Понедельник", isOn: schedule.contains(.monday)),
            SwitchOptions(weekDay: .tuesday, name: "Вторник", isOn: schedule.contains(.tuesday)),
            SwitchOptions(weekDay: .wednesday, name: "Среда", isOn: schedule.contains(.wednesday)),
            SwitchOptions(weekDay: .thursday, name: "Четверг", isOn: schedule.contains(.thursday)),
            SwitchOptions(weekDay: .friday, name: "Пятница", isOn: schedule.contains(.friday)),
            SwitchOptions(weekDay: .saturday, name: "Суббота", isOn: schedule.contains(.saturday)),
            SwitchOptions(weekDay: .sunday, name: "Воскресенье", isOn: schedule.contains(.sunday)),
        ])
    }
    
    @objc private func didTapDoneButton() {
        delegate?.didConfigure(schedule: schedule)
        dismiss(animated: true)
    }
}


extension SetScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let switchCell = tableView
            .dequeueReusableCell(withIdentifier: WeekDaysSwitchTableViewCell.identifier, for: indexPath) as? WeekDaysSwitchTableViewCell
        else {
            preconditionFailure("Type cast error")
        }
                switchCell.delegate = self
        switchCell.configure(options: switches[indexPath.row])
        
        if indexPath.row == switches.count - 1 {
            let centerX = switchCell.bounds.width / 2
            switchCell.separatorInset = UIEdgeInsets(top: 0, left: centerX, bottom: 0, right: centerX)
        }
        return switchCell
    }
}

extension SetScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SetScheduleViewController: WeekDaysSwitchTableViewCellDelegate {

    func didChangeState(isOn: Bool, for weekDay: WeekDays) {
        if isOn {
            schedule.insert(weekDay)
        } else {
            schedule.remove(weekDay)
        }
        setDoneButtonState()
    }
}
