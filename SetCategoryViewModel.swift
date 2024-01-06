//
//  SetCategoryViewModel.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.12.2023.
//

import Foundation
import UIKit

final class  SetCategoryViewModel: CreateNewCategoryViewControllerDelegate {
    func reloadCategories() {
        SetCategoryViewController().reloadCategories()
    }
    
    
    private let categoryStore = TrackerCategoryStore.shared
    var onChange: (() -> Void)?
    
    private(set) var categories: [TrackerCategory] = [] {
            didSet {
                onChange?() // сообщаем через замыкание, что ViewModel изменилась
            }
        }
    
    func getCategories() {
        categories = categoryStore.getCategories()
    }
    
    func categoriesNumber() -> Int {
        if categories.count > 0 {
            return categories.count
        } else {
            return 0
        }
    }
    
    func userPressedCategory(_ item: TrackerCategory) -> UIContextMenuConfiguration {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            
            let editAction = UIAction(title: "Редактировать") { _ in
                let viewController = CreateNewCategoryViewController()
                viewController.titleText = "Редактирование категории"
                viewController.startingString = item.name
                viewController.categoryId = item.id
                viewController.delegate = self
                SetCategoryViewController().present(viewController, animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
                
                let actionSheet: UIAlertController = {
                    let alert = UIAlertController()
                    alert.title = "Эта категория точно не нужна?"
                    return alert
                }()
                let action1 = UIAlertAction(title: "Удалить", style: .destructive) {_ in
                    self.categoryStore.deleteCategory(item.id)
                    self.reloadCategories()
                }
                let action2 = UIAlertAction(title: "Отменить", style: .cancel)
                actionSheet.addAction(action1)
                actionSheet.addAction(action2)
                SetCategoryViewController().present(actionSheet, animated: true)
            }
            return UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}
