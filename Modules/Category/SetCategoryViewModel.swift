//
//  SetCategoryViewModel.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.12.2023.
//

import Foundation
import UIKit

final class  SetCategoryViewModel {
    
    
    weak var delegate: SetCategoryViewControllerDelegate?
    private var selectedCategory: TrackerCategory?
    
    private let categoryStore = TrackerCategoryStore.shared
    var onChange: (() -> Void)?
    
    private(set) var categories: [TrackerCategory] = [] {
            didSet {
                onChange?()
            }
        }
    
    func getCategories() {
        categories = categoryStore.getCategories()
    }
    
    func categoriesNumber() -> Int {
        
        categories.count
    }
    
    func deleteCategory(_ item: TrackerCategory) {
        self.categoryStore.deleteCategory(item.id)
        getCategories()
    }
    
    func didSelectCategoryAt(indexPath: IndexPath) {
        selectedCategory = categories[indexPath.row]
        delegate?.didSetCategory(category: selectedCategory!)
    }
}
