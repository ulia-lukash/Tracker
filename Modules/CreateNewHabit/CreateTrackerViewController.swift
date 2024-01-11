//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 04.12.2023.
//

import Foundation
import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateNewTracker()
}

class CreateTrackerViewController: UIViewController {
    
    // MARK: - Public Properties

    weak var delegate: CreateTrackerViewControllerDelegate?

    // MARK: - Private Properties

    private lazy var habitButton: CustomButton = {
        let button = CustomButton()
        button.buttonLabel = "Привычка"
        button.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var irregularActionButton: CustomButton = {
        let button = CustomButton()
        button.buttonLabel = "Нерегулярные событие"
        button.addTarget(self, action: #selector(irregularActionButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configView()
    }

    // MARK: - Private Methods
    
    private func configView() {
        
        view.backgroundColor = .white
        view.addSubview(viewTitle)
        view.addSubview(habitButton)
        view.addSubview(irregularActionButton)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularActionButton.translatesAutoresizingMaskIntoConstraints = false
    
        viewTitle.textColor = UIColor(named: "Black")
        viewTitle.textAlignment = .center
        viewTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        NSLayoutConstraint.activate([
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            habitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            habitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            irregularActionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            irregularActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            irregularActionButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    // MARK: - @objc Methods
    
    @objc private func habitButtonTapped() {
        let viewController = CreateNewHabitViewController()
        viewController.delegate = self
        viewController.isHabit = true
        present(viewController, animated: true)
    }
    
    @objc private func irregularActionButtonTapped() {
        let viewController = CreateNewHabitViewController()
        viewController.delegate = self
        viewController.isHabit = false
        present(viewController, animated: true)
    }
}

extension CreateTrackerViewController: CreateNewHabitViewControllerDelegate {

    
    func createdNewHabit() {
        dismiss(animated: true)
        delegate?.didCreateNewTracker()
    }
    
    func cancelNewHabitCreation() {
        dismiss(animated: true)
    }
    
}