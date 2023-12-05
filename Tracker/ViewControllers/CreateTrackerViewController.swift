//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 04.12.2023.
//

import Foundation
import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateNewTracker(model: Tracker)
}
class CreateTrackerViewController: UIViewController {
    private let habitButton =  UIButton()
    
    private let irregularActionButton = UIButton()
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        irregularActionButton.addTarget(self, action: #selector(irregularActionButtonTapped), for: .touchUpInside)
    }
    
    private func configView() {
        
        view.backgroundColor = .white
        view.addSubview(viewTitle)
        view.addSubview(habitButton)
        view.addSubview(irregularActionButton)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        irregularActionButton.translatesAutoresizingMaskIntoConstraints = false
        
        habitButton.backgroundColor = UIColor(named: "Black")
        irregularActionButton.backgroundColor = UIColor(named: "Black")
        
        habitButton.layer.cornerRadius = 16
        irregularActionButton.layer.cornerRadius = 16
        
        habitButton.setTitle("Привычка", for: .normal)
        irregularActionButton.setTitle("Нерегулярные событие", for: .normal)
        
        habitButton.titleLabel?.textColor = .white
        irregularActionButton.titleLabel?.textColor = .white
        viewTitle.textColor = UIColor(named: "Black")
        
        habitButton.titleLabel?.textAlignment = .center
        irregularActionButton.titleLabel?.textAlignment = .center
        viewTitle.textAlignment = .center
        
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        irregularActionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        viewTitle.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        NSLayoutConstraint.activate([
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            habitButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            irregularActionButton.heightAnchor.constraint(equalToConstant: 60),
            irregularActionButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            irregularActionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            irregularActionButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
    
    @objc private func habitButtonTapped() {
        let viewController = CreateNewHabitViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc private func irregularActionButtonTapped() {
        let viewController = CreateNewIrrActionController()
        present(viewController, animated: true)
    }
   
}

extension CreateTrackerViewController: CreateNewHabitViewControllerDelegate {
    func createdNewHabit(model: Tracker) {
        dismiss(animated: true)
        delegate?.didCreateNewTracker(model: model)
        
    }
    
    func cancelNewHabitCreation() {
        dismiss(animated: true)
    }
    
    

}
