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
    
    var viewModel: SetCategoryViewModel?
    
    // MARK: - Public Properties
    
    private var trackerCategoryStore = TrackerCategoryStore()
    weak var delegate: SetCategoryViewControllerDelegate?
    private var selectedCategory: TrackerCategory?
    
    // MARK: - Private Properties
        
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var addCategoryButton: CustomButton = {
        let button = CustomButton()
        button.buttonLabel = "Добавить категорию"
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
        table.isScrollEnabled = true
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.allowsMultipleSelection = false
        return table
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        viewModel = SetCategoryViewModel()
        viewModel?.viewController? = self
        bind()
        
        viewModel?.getCategories()
//        categories =  trackerCategoryStore.getCategories()
        setPlaceholderVisibility()
        configView()
        categoriesTable.dataSource = self
        categoriesTable.delegate = self
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    private func bind() {
        guard let viewModel = viewModel else { return }

        viewModel.onChange = { [weak self] in
            self?.categoriesTable.reloadData()
            self?.setPlaceholderVisibility()
        }
    }
    
    private func addInteraction(toCell cell: UITableViewCell) {
        let interaction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(interaction)
    }
    
    private func setPlaceholderVisibility() {
        guard let viewModel = viewModel else { return }
        if viewModel.categoriesNumber() == 0 {
            placeholderPic.isHidden = false
            placeholderText.isHidden = false
            categoriesTable.isHidden = true
        } else {
            placeholderPic.isHidden = true
            placeholderText.isHidden = true
            categoriesTable.isHidden = false
        }
    }
    
    private func configView() {
        
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
            
            addCategoryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            addCategoryButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            categoriesTable.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 38),
            categoriesTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            categoriesTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            categoriesTable.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -16),
        
            
        ])
    }
    
    @objc private func addCategoryButtonTapped() {
        let viewController = CreateNewCategoryViewController()
        viewController.titleText = "Новая категория"
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension SetCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else  { return 0 }
        return viewModel.categoriesNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let reuseIdentifier = "CategoriesTableViewCell"
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        cell!.heightAnchor.constraint(equalToConstant: 75).isActive = true
        cell!.backgroundColor = UIColor(named: "Background")
        guard let viewModel = viewModel else { return cell! }
        cell!.textLabel?.text = viewModel.categories[indexPath.row].name
        if indexPath.row == viewModel.categoriesNumber() - 1 {
            cell!.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell!.layer.cornerRadius = 16
            cell!.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        cell?.selectionStyle = .none
        self.addInteraction(toCell: cell!)
        return cell!
        
    }
}

extension SetCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else { return }
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        selectedCategory = viewModel.categories[indexPath.row]
        delegate?.didSetCategory(category: selectedCategory!)
        dismiss(animated: true)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension SetCategoryViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let viewModel = viewModel else { return nil }
        let item = viewModel.categories[indexPath.row]
        
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
                
                let actionSheet: UIAlertController = {
                    let alert = UIAlertController()
                    alert.title = "Эта категория точно не нужна?"
                    return alert
                }()
                let action1 = UIAlertAction(title: "Удалить", style: .destructive) {_ in
                    viewModel.deleteCategory(item)
                }
                let action2 = UIAlertAction(title: "Отменить", style: .cancel)
                actionSheet.addAction(action1)
                actionSheet.addAction(action2)
                self.present(actionSheet, animated: true)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}

//  TODO: - Reload Data not working
extension SetCategoryViewController: CreateNewCategoryViewControllerDelegate {
    
    func reloadCategories()  {
        categoriesTable.reloadData()
    }
}
