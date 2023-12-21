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
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    let toolbar = UIToolbar()
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
    
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
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolbar.sizeToFit()
        toolbar.setItems([flexible, doneButton], animated: false)
        view.backgroundColor = .white
        configView()
    }
    
    private func configView(){
        
        view.addSubview(viewTitle)
        view.addSubview(textField)
        view.addSubview(addCategoryButton)

        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textField.textInputView.leftAnchor.constraint(equalTo: textField.leftAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addCategoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
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
    @objc func doneButtonTapped() {
        textField.resignFirstResponder()
    }
}
