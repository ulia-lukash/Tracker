//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

class TrackersViewController: UIViewController {
    
    
    private var visibleCategories: [TrackerCategory] = []
    
    private var completedRecords: [TrackerRecord] = []
    private var currentDate = Date()
    private var selectedDate = Date()
    private let widthParameters = CollectionParameters(cellsNumber: 2, leftInset: 16, rightInset: 16, interCellSpacing: 10)
    
    // - Mock tracker data
    private var categories: [TrackerCategory] = [TrackerCategory(name: "Home", trackers: [Tracker(id: UUID(), name: "Cleaning", colour: UIColor(named: "Color selection 4")!, emoji: "🌺", schedule: [.tuesday, .thursday, .saturday]), Tracker(id: UUID(), name: "Cooking", colour: UIColor(named: "Color selection 7")!, emoji: "🎡", schedule: [.monday, .wednesday, .saturday, .sunday])]), TrackerCategory(name: "Time to study", trackers: [Tracker(id: UUID(), name: "Home work", colour: UIColor(named: "Color selection 12")!, emoji: "🏝️", schedule: [.monday, .tuesday, .wednesday, .thursday, .friday]), Tracker(id: UUID(), name: "Screaming", colour: UIColor(named: "Color selection 14")!, emoji: "🎡", schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday])])]
    
    private let placeholderPic = UIImageView(image: UIImage(named: "tracker_placeholder"))
    private let placeholderText: UILabel = {
        let label = UILabel()
        
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let errorPlaceholderPic = UIImageView(image:UIImage(named: "error_tracker_placeholder"))
    private let errorPlaceholderText: UILabel = {
        let label = UILabel()
        
        label.text = "Ничего не найдено"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: TrackersViewController.self, action: #selector(didTapAddButton))
        return addButton
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Трекеры"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    
    private let datePicker = UIDatePicker()
    
    private let searchBar = UISearchBar()
    
    private let trackerCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        collection.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibleCategories = categories
        searchBar.searchTextField.addTarget(self, action: #selector(didChangeSearchText), for: .allEvents)
        datePicker.addTarget(self, action: #selector(didChangeSelectedDate), for: .allEvents)
        configTopNavBar()
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        makeViewLayout()
        visibleCategories.isEmpty ? showPlaceholder() : hidePlaceholder()
    }
    
    
    private func showPlaceholder() {
        placeholderPic.isHidden = false
        placeholderText.isHidden = false
    }
    
    private func hidePlaceholder() {
        placeholderPic.isHidden = true
        placeholderText.isHidden = true
    }
    
    private func showErrorPlaceholder() {
        errorPlaceholderPic.isHidden = false
        errorPlaceholderText.isHidden = false
    }
    
    private func hideErrorPlaceholder() {
        errorPlaceholderPic.isHidden = true
        errorPlaceholderText.isHidden = true
    }
    
    private func configTopNavBar() {
        
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        addButton.tintColor = UIColor(named: "Black")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        navigationItem.leftBarButtonItem = addButton
        
        addButton.target = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
        ])
    }
    
    private func makeViewLayout() {
        
        view.backgroundColor = UIColor(ciColor: .white)
        
        visibleCategories.isEmpty ? showPlaceholder() : hidePlaceholder()
        hideErrorPlaceholder()
        
        view.addSubview(trackerCollection)
        view.addSubview(placeholderPic)
        view.addSubview(placeholderText)
        view.addSubview(errorPlaceholderPic)
        view.addSubview(errorPlaceholderText)
        trackerCollection.translatesAutoresizingMaskIntoConstraints = false
        placeholderPic.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        errorPlaceholderPic.translatesAutoresizingMaskIntoConstraints = false
        errorPlaceholderText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8),
            errorPlaceholderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorPlaceholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorPlaceholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorPlaceholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8),
            trackerCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func isMatchRecord(model: TrackerRecord, with trackerId: UUID) -> Bool {
        return model.trackerId == trackerId && Calendar.current.isDate(model.date, inSameDayAs: selectedDate)
    }
//    private func isComplete(trackerId: UUID) -> Bool {
//        return completedRecords.contains { element in
//            if element.trackerId == trackerId && Calendar.current.isDate(element.date, equalTo: selectedDate, toGranularity: .day) {
//                return true
//            } else {
//                return false
//            }
//        }
//    }
    
    func calculateWeekDayNumber(for date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let weekDay = calendar.component(.weekday, from: date)
        let daysWeek = 7
        return (weekDay - calendar.firstWeekday + daysWeek) % daysWeek + 1
    }
    
    func updateVisibleTrackers() {
        visibleCategories = []
        
        for category in categories {
            var visibleTrackers: Array<Tracker> = []
            
            for tracker in category.trackers {
                guard let weekDay = WeekDays(rawValue: calculateWeekDayNumber(for: selectedDate)),
                      ((tracker.schedule?.contains(weekDay)) != nil)
                else {
                    continue
                }
                visibleTrackers.append(tracker)
            }
            if !visibleTrackers.isEmpty {
                visibleCategories.append(TrackerCategory(name: category.name, trackers: visibleTrackers))
            }
        }
        visibleCategories.isEmpty ? showPlaceholder() : hidePlaceholder()
        hideErrorPlaceholder()
        trackerCollection.reloadData()
    }
    
    @objc private func didTapAddButton() {
        
        let viewController = CreateTrackerViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc func didChangeSelectedDate() {
        visibleCategories = []
        selectedDate = datePicker.date
        for category in categories {
            var dateSortedTrackers: Array<Tracker> = []
            
            for tracker in category.trackers {
                guard let weekDay = WeekDays(rawValue: calculateWeekDayNumber(for: selectedDate)) else { continue }
                guard let doesContain = tracker.schedule?.contains(weekDay) else {continue}
                if doesContain {
                    dateSortedTrackers.append(tracker)
                }
                
                
            }
            if !dateSortedTrackers.isEmpty {
                visibleCategories.append(TrackerCategory(name: category.name, trackers: dateSortedTrackers))
            }
        }
        visibleCategories.isEmpty ? showPlaceholder() : hidePlaceholder()
        hideErrorPlaceholder()
        trackerCollection.reloadData()

        
    }
    
    @objc func didChangeSearchText() {
        guard let searchText = searchBar.text,
              !searchText.isEmpty
        else {
            return
        }
        var searchedCategories: Array<TrackerCategory> = []
        for category in categories {
            var searchedTrackers: Array<Tracker> = []
            
            for tracker in category.trackers {
                if tracker.name.localizedCaseInsensitiveContains(searchText) {
                    searchedTrackers.append(tracker)
                }
            }
            if !searchedTrackers.isEmpty {
                searchedCategories.append(TrackerCategory(name: category.name, trackers: searchedTrackers))
            }
        }
        visibleCategories = searchedCategories
        visibleCategories.isEmpty ? showErrorPlaceholder() : hideErrorPlaceholder()
        hidePlaceholder()
        trackerCollection.reloadData()
    }
    private let mockCategory: Array<String> = [
        "Важное",
        "Радостные мелочи",
        "Самочувствие",
        "Внимательность",
        "Спорт"
    ]
}

extension  TrackersViewController: CreateTrackerViewControllerDelegate {
    
    
    func didCreateNewTracker(model: Tracker) {        categories[0].trackers.append(model)
        updateVisibleTrackers()
        trackerCollection.reloadData()
    }
    
    
}


extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - widthParameters.widthInsets
        let cellWidth = availableWidth / CGFloat(widthParameters.cellsNumber)
        return CGSize(width: cellWidth, height: 132)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: widthParameters.leftInset, bottom: 8, right: widthParameters.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let targetSize = CGSize(width: collectionView.bounds.width, height: 42)
        
        return headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else {
            preconditionFailure("Failed to cast UICollectionViewCell as TrackerCollectionViewCell")
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
                let isCompleted = completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
//        let isCompleted = isComplete(trackerId: tracker.id)
        let completedDays = completedRecords.filter { $0.trackerId == tracker.id }.count
        
        trackerCell.delegate = self
        trackerCell.configure(model: tracker, at: indexPath, isCompleted: isCompleted, completedDays: completedDays)
        
        return trackerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let trackerHeader = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackerCollectionViewHeader.identifier, for: indexPath) as? TrackerCollectionViewHeader
        else {
            preconditionFailure("Failed to cast UICollectionReusableView as TrackerCollectionViewHeader")
        }
        trackerHeader.configure(model: visibleCategories[indexPath.section])
        return trackerHeader
    }
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    
    func markComplete(with id: UUID) {
        guard selectedDate <= Date() else {
            return
        }
        completedRecords.append(TrackerRecord(trackerId: id, date: selectedDate))
        trackerCollection.reloadData()
    }
    
    func undoMarkComplete(with id: UUID) {
        completedRecords.removeAll { element in
            if (element.trackerId == id &&  Calendar.current.isDate(element.date, equalTo: selectedDate, toGranularity: .day)) {
                return true
            } else {
                return false
            }
        }
        trackerCollection.reloadData()
    }
}
