//
//  SetCategoryViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation
import UIKit

protocol SetCategoryViewControllerDelegate: AnyObject {
    
    func didSetCategory(category: TrackerCategory)
}

class SetCategoryViewController: UIViewController {
    
    // MARK: - Public Properties
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    weak var delegate: SetCategoryViewControllerDelegate?
    private var selectedCategory: TrackerCategory?
    var categories: [TrackerCategory] = []
    // MARK: - Private Properties
    
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "Black")
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var placeholderPic = UIImageView(image: UIImage(named: "tracker_placeholder"))
    
    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var categoriesTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.register(CategoriesTableViewCell.self, forCellReuseIdentifier: CategoriesTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.allowsMultipleSelection = false
        return table
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
        setPlaceholderVisibility()
        configView()
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func setPlaceholderVisibility() {
        if categories.isEmpty {
            placeholderPic.isHidden = false
            placeholderText.isHidden = false
            categoriesTable.isHidden = true
        } else {
            placeholderPic.isHidden = true
            placeholderText.isHidden = true
            categoriesTable.isHidden = false
        }
    }
    private func fetchCategories() {
        categories = trackerCategoryStore.getCategories()
    }
    
    private func configView() {
        let tableHeight = CGFloat(categories.count * 75)
        view.backgroundColor = .white
        view.addSubview(viewTitle)
        view.addSubview(addCategoryButton)
        view.addSubview(placeholderPic)
        view.addSubview(placeholderText)
        view.addSubview(categoriesTable)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderPic.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            placeholderPic.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addCategoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            categoriesTable.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            categoriesTable.heightAnchor.constraint(equalToConstant: tableHeight),
            categoriesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    
    @objc private func addCategoryButtonTapped() {
        let viewController = CreateNewCategoryViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension SetCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "CategoriesTableViewCell"
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        cell!.textLabel?.text = categories[indexPath.row].name
        
        return cell!
        
    }
}


extension SetCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: - Добавить галки при выборе
        selectedCategory = categories[indexPath.row]
        delegate?.didSetCategory(category: selectedCategory!)
//        TODO: - Should it be here? Should it not?
//        dismiss(animated: true)
    }
}

//  TODO: - Reload Data not working
extension SetCategoryViewController: CreateNewCategoryViewControllerDelegate {
    func addNewCategory(named name: String) {
        let newCategory = TrackerCategory(id: UUID(), name: name, trackers: [])
        trackerCategoryStore.saveCategoryToCoreData(newCategory)
        categories = trackerCategoryStore.getCategories()
        categoriesTable.reloadData()
    }
}
