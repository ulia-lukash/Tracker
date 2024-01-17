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
    
    var catsAtt: [TrackerCategory] = []
    // MARK: - Private Properties
    
    private var currentFilter: String?
    private let widthParameters = CollectionParameters(cellsNumber: 2, leftInset: 16, rightInset: 16, interCellSpacing: 10)
    private var filteredData: [TrackerCategory] = []
    private var completedRecords: [TrackerRecord] = []
    private var selectedDate = Date()
    private var categories: [TrackerCategory] = []
    
    private lazy var actionSheet: UIAlertController = {
        let alert = UIAlertController()
        alert.title = NSLocalizedString("Delete category confirmation", comment: "")
        return alert
    }()
    private lazy var placeholderPic = UIImageView(image: UIImage(named: "tracker_placeholder"))
    private lazy var placeholderText: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("Trackers placeholder", comment: "")
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var errorPlaceholderPic = UIImageView(image:UIImage(named: "error_tracker_placeholder"))
    private lazy var errorPlaceholderText: UILabel = {
        let label = UILabel()
        
        label.text = NSLocalizedString("No trackers found", comment: "")
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: TrackersViewController.self, action: #selector(didTapAddButton))
        return addButton
    }()
    
    private lazy var datePicker = UIDatePicker()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "")
        return searchController
    }()
    private lazy var trackerCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.backgroundColor = UIColor(named: "White")
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
    //    TODO: finish filters butttons
    private lazy var filtersButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "Blue")
        button.setTitle(NSLocalizedString("Filters", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapFiltersButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad()   {
        
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "White")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        
        selectedDate = Date()
        initialTrackersFilter()
        setInitialPlaceholderVisibility()
        searchController.searchResultsUpdater = self
        categories = categoryStore.getCategories()
        completedRecords = trackerRecordStore.getCompletedTrackers()
        
        datePicker.addTarget(self, action: #selector(didChangeSelectedDate), for: .valueChanged)
        configTopNavBar()
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        configView()
    }
    
    @objc func endEditing() {
        searchController.searchBar.endEditing(true)    }
    
    func setInitialPlaceholderVisibility() {
        let numberOfTrackers = trackerStore.getNumberOfTrackers()
        if numberOfTrackers == 0 {
            filteredData = []
            showPlaceholder()
        }
        
    }
    // MARK: - Private Methods
    
    private func initialTrackersFilter() {
        categories = categoryStore.getCategories()
        if let pinnedCategory = categoryStore.fetchCategoryWithName(NSLocalizedString("Pinned", comment: "")) {
            let filteredCategories = categories.filter { category in
                category.name == NSLocalizedString("Pinned", comment: "") ? false : true
            }
            categories = categoryStore.transformCoredataCategories([pinnedCategory]) + filteredCategories
        }
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
        placeholderPic.isHidden = true
        placeholderText.isHidden = true
        errorPlaceholderPic.isHidden = false
        errorPlaceholderText.isHidden = false
    }
    private func hideErrorPlaceholder() {
        errorPlaceholderPic.isHidden = true
        errorPlaceholderText.isHidden = true
    }
    private func configTopNavBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.title = NSLocalizedString("Trakers", comment: "")
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationItem.leftBarButtonItem = addButton
        
        addButton.tintColor = UIColor(named: "Black")
        addButton.target = self
        
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru")
        
        NSLayoutConstraint.activate([
            datePicker.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    private func configView() {
        
        filteredData.isEmpty ? showPlaceholder() : hidePlaceholder()
        hideErrorPlaceholder()
        
        view.addSubview(trackerCollection)
        view.addSubview(placeholderPic)
        view.addSubview(placeholderText)
        view.addSubview(errorPlaceholderPic)
        view.addSubview(errorPlaceholderText)
        
        view.addSubview(filtersButton)
        
        trackerCollection.translatesAutoresizingMaskIntoConstraints = false
        placeholderPic.translatesAutoresizingMaskIntoConstraints = false
        placeholderText.translatesAutoresizingMaskIntoConstraints = false
        errorPlaceholderPic.translatesAutoresizingMaskIntoConstraints = false
        errorPlaceholderText.translatesAutoresizingMaskIntoConstraints = false
        
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8),
            errorPlaceholderPic.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorPlaceholderPic.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorPlaceholderText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorPlaceholderText.topAnchor.constraint(equalTo: placeholderPic.bottomAnchor, constant: 8),
            trackerCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackerCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackerCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
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
        selectedDate = datePicker.date
        if let currentFilter = currentFilter {
            switch currentFilter {
            case NSLocalizedString("Completed", comment: ""):
                filterCompletedTrackersForSelectedDate()
                break
            case NSLocalizedString("Not completed", comment: ""):
                filterNotCompletedTrackersForSelectedDate()
                break
            default:
                break
            }
        } else {
            selectedDate = datePicker.date
            initialTrackersFilter()
        }
        
        trackerCollection.reloadData()
        
        filteredData.isEmpty ? showErrorPlaceholder() : hideErrorPlaceholder()
    }
    
    @objc private func didTapFiltersButton() {
        let viewController = FiltersViewController()
        viewController.delegate = self
        if let currentFilter = currentFilter {
            if currentFilter == NSLocalizedString("Completed", comment: "") || currentFilter == NSLocalizedString("Not completed", comment: "") {
                viewController.currentFilter = currentFilter
            }
        }
        self.present(viewController, animated: true)
        
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
        
        let isPinned = filteredData[indexPath.section].name == NSLocalizedString("Pinned", comment: "") ? true : false
        let isCompleted = completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
        let completedDays = completedRecords.filter { $0.trackerId == tracker.id }.count
        
        trackerCell.delegate = self
        trackerCell.configure(model: tracker, at: indexPath, isCompleted: isCompleted, completedDays: completedDays, isPinned: isPinned)
        
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
    func pinTracker(withId id: UUID) {
        trackerStore.pinTracker(withId: id)
        self.categories = self.categoryStore.getCategories()
        self.completedRecords = self.trackerRecordStore.getCompletedTrackers()
        self.initialTrackersFilter()
        self.setInitialPlaceholderVisibility()
        self.trackerCollection.reloadData()
    }
    
    func deleteTracker(withId id: UUID) {
        
        let actionSheet: UIAlertController = {
            let alert = UIAlertController()
            alert.title = NSLocalizedString("Delete category confirmation", comment: "")
            return alert
        }()
        let action1 = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) {_ in
            self.trackerStore.deleteTracker(withId: id)
            self.categories = self.categoryStore.getCategories()
            self.completedRecords = self.trackerRecordStore.getCompletedTrackers()
            self.initialTrackersFilter()
            self.setInitialPlaceholderVisibility()
            self.trackerCollection.reloadData()
        }
        let action2 = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        present(actionSheet, animated: true)
    }
    
    func editTracker(withId id: UUID) {
        let trackerCoreData = trackerStore.fetchTrackerWithId(id)
        let tracker = trackerStore.convertToTracker(coreDataTracker: trackerCoreData)
        let viewController = CreateNewHabitViewController()
        if tracker.schedule?.count == 7 {
            viewController.isHabit = false
        } else {
            viewController.isHabit = true
        }
        
        viewController.isEdit = true
        viewController.tracker = trackerCoreData
        viewController.delegate = self
        
        present(viewController, animated: true)
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        categories = categoryStore.getCategories()
        
        if let text = searchController.searchBar.text {
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
        if searchController.searchBar.text == "" && filteredData.isEmpty {
            hideErrorPlaceholder()
            showPlaceholder()
        }
    }
    /**
     Filters categories and their corresponding trackers in accordance with selected day
     */
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

extension TrackersViewController: CreateNewHabitViewControllerDelegate {
    func createdNewHabit() {
        self.didCreateNewTracker()
    }
    
    func cancelNewHabitCreation() {
        
    }
}

extension TrackersViewController: FiltersViewControllerDelegate {
    func didSelectFilter(_ filter: String) {
        currentFilter = filter
        switch filter {
        case NSLocalizedString("All trackers", comment: ""):
            print(currentFilter)
            initialTrackersFilter()
            trackerCollection.reloadData()
            break
        case NSLocalizedString("Trackers for today", comment: ""):
            datePicker.date = Date()
            didChangeSelectedDate()
            break
        case NSLocalizedString("Completed", comment: ""):
            filterCompletedTrackersForSelectedDate()
            break
        case NSLocalizedString("Not completed", comment: ""):
            filterNotCompletedTrackersForSelectedDate()
            break
        default:
            break
        }
    }
    
    func didDeselectFilter() {
        self.currentFilter = nil
        initialTrackersFilter()
    }
    
    private func filterNotCompletedTrackersForSelectedDate() {
        categories = categoryStore.getCategories()
        if let pinnedCategory = categoryStore.fetchCategoryWithName(NSLocalizedString("Pinned", comment: "")) {
            let filteredCategories = categories.filter { category in
                category.name == NSLocalizedString("Pinned", comment: "") ? false : true
            }
            categories = categoryStore.transformCoredataCategories([pinnedCategory]) + filteredCategories
        }
        filteredData = []
        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                let isCompleted = completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
                if !isCompleted {
                    return isTrackerScheduledOnSelectedDate(tracker)
                } else {
                    return false
                }
            }
            if !filteredTrackers.isEmpty {
                filteredData.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredTrackers))
            }
        }
        trackerCollection.reloadData()
        if filteredData.isEmpty {
            showErrorPlaceholder()
        }
        
    }
    
    private func filterCompletedTrackersForSelectedDate() {
        categories = categoryStore.getCategories()
        if let pinnedCategory = categoryStore.fetchCategoryWithName(NSLocalizedString("Pinned", comment: "")) {
            let filteredCategories = categories.filter { category in
                category.name == NSLocalizedString("Pinned", comment: "") ? false : true
            }
            categories = categoryStore.transformCoredataCategories([pinnedCategory]) + filteredCategories
        }
        filteredData = []
        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                let isCompleted = completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
                if isCompleted {
                    return isTrackerScheduledOnSelectedDate(tracker)
                } else {
                    return false
                }
            }
            if !filteredTrackers.isEmpty {
                filteredData.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredTrackers))
            }
        }
        trackerCollection.reloadData()
        if filteredData.isEmpty {
            showErrorPlaceholder()
        }
    }
}
