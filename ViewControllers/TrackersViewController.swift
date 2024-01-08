//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit
import CoreData


class TrackersViewController: UIViewController  {
    
    let categoryStore = TrackerCategoryStore.shared
    let trackerRecordStore = TrackerRecordStore.shared
    let trackerStore = TrackerStore.shared
    
    //    Will have to move CoreData logic to separate files
    
    var catsAtt: [TrackerCategory] = []
    // MARK: - Private Properties
    
    private let widthParameters = CollectionParameters(cellsNumber: 2, leftInset: 16, rightInset: 16, interCellSpacing: 10)
    private var filteredData: [TrackerCategory] = []
    private var completedRecords: [TrackerRecord] = []
    private var selectedDate = Date()
    private var categories: [TrackerCategory] = []
    
    private lazy var actionSheet: UIAlertController = {
        let alert = UIAlertController()
        alert.title = "Эта категория точно не нужна?"
        return alert
    }()
    private lazy var placeholderPic = UIImageView(image: UIImage(named: "tracker_placeholder"))
    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var errorPlaceholderPic = UIImageView(image:UIImage(named: "error_tracker_placeholder"))
    private lazy var errorPlaceholderText: UILabel = {
        let label = UILabel()
        
        label.text = "Ничего не найдено"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: TrackersViewController.self, action: #selector(didTapAddButton))
        return addButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Трекеры"
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private lazy var datePicker = UIDatePicker()
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var trackerCollection: UICollectionView = {
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
    
    // MARK: - UIViewController
    
    override func viewDidLoad()   {
        
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        
        selectedDate = Date()
        initialTrackersFilter()
        setInitialPlaceholderVisibility()
        searchBar.delegate = self
        categories = categoryStore.getCategories()
        completedRecords = trackerRecordStore.getCompletedTrackers()
        
        datePicker.addTarget(self, action: #selector(didChangeSelectedDate), for: .valueChanged)
        configTopNavBar()
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        configView()
    }
    
    @objc func endEditing() {
        searchBar.endEditing(true)
    }
    
    func setInitialPlaceholderVisibility() {
        let numberOfTrackers = trackerStore.getNumberOfTrackers()
        if numberOfTrackers == 0 {
            filteredData = []
        }
    }
    // MARK: - Private Methods
    
    private func initialTrackersFilter() {
        categories = categoryStore.getCategories()
        filteredData = []
        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                return isTrackerScheduledOnSelectedDate(tracker)
            }
            if !filteredTrackers.isEmpty {
                filteredData.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredTrackers))
            }
        }
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
        datePicker.locale = Locale(identifier: "ru_RU")
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        navigationItem.leftBarButtonItem = addButton
        
        addButton.target = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
        ])
    }
    
    private func configView() {
        
        view.backgroundColor = UIColor(ciColor: .white)
        
        filteredData.isEmpty ? showPlaceholder() : hidePlaceholder()
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
    
    private func isTrackerScheduledOnSelectedDate(_ tracker: Tracker) -> Bool {
        guard let weekDay = WeekDays(rawValue: calculateWeekDayNumber(for: selectedDate)) else { return false }
        return tracker.schedule?.contains(weekDay) ?? false
    }
    private func calculateWeekDayNumber(for date: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        let weekDay = calendar.component(.weekday, from: date)
        let daysWeek = 7
        return (weekDay - calendar.firstWeekday + daysWeek) % daysWeek + 1
    }
    
    private func updateVisibleTrackers() {
        filteredData = []
        categories = categoryStore.getCategories()
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
                filteredData.append(TrackerCategory(id: UUID(), name: category.name, trackers: visibleTrackers))
            }
        }
        filteredData.isEmpty ? showPlaceholder() : hidePlaceholder()
        hideErrorPlaceholder()
        trackerCollection.reloadData()
    }
    
    // MARK: - @objc Methods
    
    @objc private func didTapAddButton() {
        
        let viewController = CreateTrackerViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc private func didChangeSelectedDate() {
        filteredData = []
        categories = categoryStore.getCategories()
        selectedDate = datePicker.date
        for category in categories {
            var dateSortedTrackers: Array<Tracker> = []
            
            for tracker in category.trackers {
                
                if isTrackerScheduledOnSelectedDate(tracker) {
                    dateSortedTrackers.append(tracker)
                }
                
                
            }
            if !dateSortedTrackers.isEmpty {
                filteredData.append(TrackerCategory(id: UUID(), name: category.name, trackers: dateSortedTrackers))
            }
        }
        filteredData.isEmpty ? showPlaceholder() : hidePlaceholder()
        hideErrorPlaceholder()
        trackerCollection.reloadData()
    }
    
}

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    
    func didCreateNewTracker() {
        
        hidePlaceholder()
        initialTrackersFilter()
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
        return filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let trackerCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else {
            preconditionFailure("Failed to cast UICollectionViewCell as TrackerCollectionViewCell")
        }
        
        let tracker = filteredData[indexPath.section].trackers[indexPath.item]
        
        
        let isCompleted = completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
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
        trackerHeader.configure(model: filteredData[indexPath.section])
        return trackerHeader
    }
}

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    
    func markComplete(with id: UUID) {
        guard selectedDate <= Date() else {
            return
        }
        
        trackerRecordStore.saveTrackerRecordCoreData(TrackerRecord(trackerId: id, date: selectedDate))
        completedRecords = trackerRecordStore.getCompletedTrackers()
        trackerCollection.reloadData()
    }
    
    func undoMarkComplete(with id: UUID) {
        guard selectedDate <= Date() else {
            return
        }
        if completedRecords.contains(where: { $0.trackerId == id && Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .day)}) {
            trackerRecordStore.deleteTrackerRecord(with: id, on: selectedDate)
        }
        completedRecords = trackerRecordStore.getCompletedTrackers()
        trackerCollection.reloadData()
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        categories = categoryStore.getCategories()
        
        if let text = searchBar.text {
            if text.count > 0 {
                var searchedCategories: Array<TrackerCategory> = []
                for category in categories {
                    var searchedTrackers: Array<Tracker> = []
                    
                    for tracker in category.trackers{
                        if tracker.name.localizedCaseInsensitiveContains(text) && isTrackerScheduledOnSelectedDate(tracker) {
                            searchedTrackers.append(tracker)
                        }
                    }
                    if !searchedTrackers.isEmpty {
                        searchedCategories.append(TrackerCategory(id: UUID(), name: category.name, trackers: searchedTrackers))
                    }
                }
                filteredData = searchedCategories
                
            } else {
                filterSelectedDateCategories()
            }
        } else {
            filterSelectedDateCategories()
        }
       
        trackerCollection.reloadData()
        filteredData.isEmpty ? showErrorPlaceholder() : hideErrorPlaceholder()
    }
    
    private func filterSelectedDateCategories() {
        filteredData = []
        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                if isTrackerScheduledOnSelectedDate(tracker) {
                    return true
                } else {
                    return false
                }
            }
            if !filteredTrackers.isEmpty {
                filteredData.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredTrackers))
            }
        }
    }
}

extension TrackersViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            
            let pinAction = UIAction(title: "Закрепить") { _ in
                
            }
            let editAction = UIAction(title: "Редактировать") { _ in
//                let viewController = CreateNewCategoryViewController()
//                viewController.titleText = "Редактирование категории"
//                viewController.startingString = item.name
//                viewController.categoryId = item.id
//                viewController.delegate = self
//                self.present(viewController, animated: true)
            }
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { _ in
//                self.presentActionSheetForCategory(item.id)
            }
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        }
    }
    
    private func presentActionSheetForCategory(_ id: UUID) {
        let action1 = UIAlertAction(title: "Удалить", style: .destructive) {_ in
//            self.trackerCategoryStore.deleteCategory(id)
//            self.reloadCategories()
        }
        let action2 = UIAlertAction(title: "Отменить", style: .cancel)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        present(actionSheet, animated: true)
    }
}
