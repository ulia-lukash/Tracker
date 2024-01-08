//
//  SetCategoryViewModel.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.12.2023.
//

import Foundation
import UIKit

final class  SetCategoryViewModel {
    
    var viewController: SetCategoryViewController?
    
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
    
    func deleteCategory(_ item: TrackerCategory) {
        self.categoryStore.deleteCategory(item.id)
        getCategories()
    }
}
