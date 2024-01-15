//
//  CreateNewCategoryViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 06.12.2023.
//

import Foundation
import UIKit

protocol CreateNewCategoryViewControllerDelegate {
    func reloadCategories()
}
final class CreateNewCategoryViewController: UIViewController {
        
    var delegate: CreateNewCategoryViewControllerDelegate?
    var categoryId: UUID?
    var titleText: String?
    var startingString: String = ""
    
    private var trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = titleText
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.text = startingString
        textField.backgroundColor = UIColor(named: "Background")
        textField.textColor = UIColor(named: "Black")
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(setButtonState), for: .allEditingEvents)
        return textField
    }()

    
    private lazy var addCategoryButton: CustomButton = {
        let button = CustomButton()
        button.buttonLabel = "Готово"
        button.backgroundColor = UIColor(named: "Gray")
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .white
        configView()
    }
    
    @objc func endEditing() {
        textField.endEditing(true)
    }
    private func configView(){
        
        view.addSubview(viewTitle)
        view.addSubview(textField)
        view.addSubview(addCategoryButton)

        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.textInputView.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    @objc private func addCategoryButtonTapped()  {
        guard let categoryName = textField.text else { return }
        
        if let categoryId = self.categoryId {
            trackerCategoryStore.renameCategory(categoryId, newName: categoryName)
        } else {
            let newCategory = TrackerCategory(id: UUID(), name: categoryName, trackers: [])
            trackerCategoryStore.saveCategoryToCoreData(newCategory)
            delegate?.reloadCategories()
        }
         
        dismiss(animated: true)
    }
    
    @objc private func setButtonState() {
        guard let categoryName = textField.text else {
            return
        }
        if categoryName.isEmpty {
            addCategoryButton.backgroundColor = UIColor(named: "Gray")
            addCategoryButton.isEnabled = false
        } else {
            addCategoryButton.backgroundColor = UIColor(named: "Black")
            addCategoryButton.isEnabled = true
        }
    }
    
    
    
}
