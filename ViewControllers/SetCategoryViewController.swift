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
    
    private lazy var actionSheet: UIAlertController = {
        let alert = UIAlertController()
        alert.title = "Эта категория точно не нужна?"
        return alert
    }()

    
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
    
    private lazy var scrollView = UIScrollView()
    private let scrollViewContent = UIView()
    
    // MARK: - UIViewController
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        categories =  trackerCategoryStore.getCategories()
        setPlaceholderVisibility()
        setUpScrollViewContent()
        configView()
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
        
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func addInteraction(toCell cell: UITableViewCell) {
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }
    
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

    private func setUpScrollViewContent() {
        let tableHeight = CGFloat(categories.count * 75)

        scrollViewContent.addSubview(categoriesTable)
        
        categoriesTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriesTable.heightAnchor.constraint(equalToConstant: tableHeight),
            categoriesTable.topAnchor.constraint(equalTo: scrollViewContent.topAnchor),
            categoriesTable.leftAnchor.constraint(equalTo: scrollViewContent.leftAnchor),
            categoriesTable.rightAnchor.constraint(equalTo: scrollViewContent.rightAnchor)
        ])
    }
    private func configView() {

        let tableHeight = CGFloat(categories.count * 75)
        
        view.backgroundColor = .white
        view.addSubview(viewTitle)
        view.addSubview(addCategoryButton)
        view.addSubview(placeholderPic)
        view.addSubview(placeholderText)
        view.addSubview(scrollView)
        
        scrollView.addSubview(scrollViewContent)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        placeholderPic.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            scrollView.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContent.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            scrollViewContent.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollViewContent.heightAnchor.constraint(equalToConstant: tableHeight)
        ])
    }
    
    
    @objc private func addCategoryButtonTapped() {
        let viewController = CreateNewCategoryViewController()
        viewController.titleText = "Новая привычка"
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension SetCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("!!!!!!!", categories.count)
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "CategoriesTableViewCell"
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell!.heightAnchor.constraint(equalToConstant: 75).isActive = true
        cell!.backgroundColor = UIColor(named: "Background")
        
        cell!.textLabel?.text = categories[indexPath.row].name

        cell?.selectionStyle = .none
        self.addInteraction(toCell: cell!)
        return cell!
        
    }
}


extension SetCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedCategory = categories[indexPath.row]
        delegate?.didSetCategory(category: selectedCategory!)
        //        TODO: - Should it be here? Should it not?
        //        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

//  TODO: - Reload Data not working
extension SetCategoryViewController: CreateNewCategoryViewControllerDelegate {
    
    func reloadCategories()  {
        categories =  trackerCategoryStore.getCategories()
        categoriesTable.reloadData()
    }
}

extension SetCategoryViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let item = categories[indexPath.row]

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            
            let editAction = UIAction(title: "Редактировать") { _ in
                let viewController = CreateNewCategoryViewController()
                viewController.titleText = "Редактирование категории"
                viewController.startingString = item.name
                viewController.categoryId = item.id
                viewController.delegate = self
                self.present(viewController, animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
                self.presentActionSheetForCategory(item.id)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
        }
    private func presentActionSheetForCategory(_ id: UUID) {
        let action1 = UIAlertAction(title: "Удалить", style: .destructive) {_ in
            self.trackerCategoryStore.deleteCategory(id)
            self.reloadCategories()
        }
        let action2 = UIAlertAction(title: "Отменить", style: .cancel)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        present(actionSheet, animated: true)
    }
}
