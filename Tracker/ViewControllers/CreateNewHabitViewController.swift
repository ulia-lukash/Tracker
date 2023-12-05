//
//  CreateNewHabitViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation
import UIKit

protocol CreateNewHabitViewControllerDelegate: AnyObject {
    func createdNewHabit(model: Tracker)
    func cancelNewHabitCreation()
    
}
class CreateNewHabitViewController: UIViewController {

    weak var delegate: CreateNewHabitViewControllerDelegate?
    private var settings: Array<SettingOptions> = []
    private var configuredSchedule: Set<WeekDays> = []
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Новая привычка"
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(named: "Background [day]")
        textField.textColor = UIColor(named: "Black")
        textField.placeholder = "Введите название трекера"
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightViewMode = .always
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "Red")!.cgColor
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.layer.cornerRadius = 16
        return cancelButton
    }()
    
    private let settingTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.heightAnchor.constraint(equalToConstant: 150).isActive = true
        return table
    }()
    
    private let createButton: UIButton = {
        let createButton = UIButton()
        createButton.backgroundColor = UIColor(named: "Gray")
        createButton.tintColor = .white
        createButton.setTitle("Создать", for: .normal)
        createButton.layer.cornerRadius = 16
        return createButton
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTable.dataSource = self
        settingTable.delegate = self
        appendSettingsToList()
        view.backgroundColor = .white
        configView()
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func appendSettingsToList() {
        settings.append(
            SettingOptions(
                name: "Категория",
                pickedParameter: nil,
                handler: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.setCategory()
                }
            ))
        settings.append(
            SettingOptions(
                name: "Расписание",
                pickedParameter: nil,
                handler: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.setSchedule()
                }
            ))
    }
    
    private func setCategory() {
        let setCategoryController = SetCategoryViewController()
//                setCategoryController.delegate = self
        present(UINavigationController(rootViewController: setCategoryController), animated: true)
    }
    
    private func setSchedule() {
        let setScheduleController = SetScheduleViewController()
                setScheduleController.delegate = self
        present(UINavigationController(rootViewController: setScheduleController), animated: true)
    }
    
    private func configView(){
        
        view.addSubview(viewTitle)
        view.addSubview(textField)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        view.addSubview(settingTable)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.textInputView.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            cancelButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            settingTable.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            settingTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            settingTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: false)
        delegate?.cancelNewHabitCreation()
        
    }
    
    @objc private func didTapCreateButton() {
        dismiss(animated: false)
        guard let trackerName = textField.text else { return }
        let newHabit = Tracker(id: UUID(), name: trackerName, colour: UIColor(named: "Color selection 14")!, emoji: "💐", schedule: configuredSchedule)
        delegate?.createdNewHabit(model: newHabit)
        
    }
    
    @objc private func setCreateButtonState() {
        guard let habitName = textField.text else {
            return
        }
        if habitName.isEmpty || configuredSchedule.isEmpty {
            createButton.backgroundColor = UIColor(named: "Gray")
            createButton.isEnabled = false
        } else {
            createButton.backgroundColor = UIColor(named: "Black")
            createButton.isEnabled = true
        }
    }
}

extension CreateNewHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView
            .dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell
        else {
            preconditionFailure("Type cast error")
        }
        settingCell.configure(options: settings[indexPath.row])
        
        if indexPath.row == settings.count - 1 {
            let centerX = settingCell.bounds.width / 2
            settingCell.separatorInset = UIEdgeInsets(top: 0, left: centerX, bottom: 0, right: centerX)
        }
        return settingCell
    }
}

extension CreateNewHabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
}

extension CreateNewHabitViewController: SetScheduleViewControllerDelegate {
    func didConfigure(schedule: Set<WeekDays>) {
        configuredSchedule = schedule
        setCreateButtonState()
        dismiss(animated: true)
    }
    
    
}
struct SettingOptions {
    let name: String
    // - TODO: Отображение категории/расписания после выбора...
    let pickedParameter: Any?
    let handler: () -> Void
}
