//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 17.01.2024.
//

import Foundation
import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: String)
    func didDeselectFilter()
}

final class FiltersViewController: UIViewController {
    
    weak var delegate: FiltersViewControllerDelegate?
    var currentFilter: String?
    
    private let filters = [
        NSLocalizedString("All trackers", comment: ""),
        NSLocalizedString("Trackers for today", comment: ""),
        NSLocalizedString("Completed", comment: ""),
        NSLocalizedString("Not completed", comment: "")
    ]
    
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = NSLocalizedString("Filters", comment: "")
        return label
    }()
    
    private lazy var filtersTable: UITableView = {
        let table = UITableView()
        table.register(FiltersTableViewCell.self, forCellReuseIdentifier: FiltersTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.allowsMultipleSelection = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersTable.dataSource = self
        filtersTable.delegate = self
        
        setUpView()
    }
    
    private func setUpView() {
        
        view.backgroundColor = UIColor(named: "White")
        
        view.addSubview(viewTitle)
        view.addSubview(filtersTable)
        
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        filtersTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            viewTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            
            filtersTable.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 24),
            filtersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filtersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filtersTable.heightAnchor.constraint(equalToConstant: 300),
            
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "FiltersTableViewCell"
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        cell!.textLabel?.text = filters[indexPath.row]
        
        if currentFilter == filters[indexPath.row] {
            self.filtersTable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell?.isSelected = true
        }
        
        return cell!
    }
    
    
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        self.dismiss(animated: true)
        delegate?.didSelectFilter(filters[indexPath.row])
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        delegate?.didDeselectFilter()
    }
}
