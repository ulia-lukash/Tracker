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
    
    // MARK: - Private Properties
    
    private let categoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    private let analyticsService = AnalyticsService.shared
    
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
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(didChangeSelectedDate), for: .valueChanged)
        return datePicker
    }()
    
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
        
        searchController.searchResultsUpdater = self
        trackerCollection.dataSource = self
        trackerCollection.delegate = self
        
        selectedDate = Date()
        
        filteredData = getAndFilterTrackersBySelectedDate()
        
        completedRecords = trackerRecordStore.getCompletedTrackers()
        
        configView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    
    
    // MARK: - Private Methods
    /**
     Adds addButton, viewTitle, datePicker and searchController to the view, and sets constraints.
     */
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
    
    /**
     Sets constraints for other elements such as the trackers collection and the filters button.
     */
    private func configView() {
        
        configTopNavBar()
        updateCollectionView()
        
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
    
    /// Checks if tracker has been completed on selected day
    /// - Parameter model: an existing tracker record for certain tracker
    /// - Parameter trackerId: tracker's id
    private func isMatchRecord(model: TrackerRecord, with trackerId: UUID) -> Bool {
        return model.trackerId == trackerId && Calendar.current.isDate(model.date, inSameDayAs: selectedDate)
    }
    
    /// Checks if tracker should be displayed on selected date
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
    
    /// Fetches trackers from DataBase and filters them depending on selected date, always placing pinned ones into separate category for demonstration.
    private func getAndFilterTrackersBySelectedDate() -> [TrackerCategory] {

        self.categories = categoryStore.getCategories()

        setPlaceholderVisibility()

        var filteredCategories: [TrackerCategory] = []

        var pinnedTrackers: [Tracker] = []

        for category in categories {
            let filteredByDateTrackers = category.trackers.filter { tracker in
                return isTrackerScheduledOnSelectedDate(tracker)
            }
            let filteredByPinnedTrackers = filteredByDateTrackers.filter { tracker in
                if tracker.isPinned {
                    pinnedTrackers.append(tracker)
                    return false
                } else {
                    return true
                }
            }
            if !filteredByPinnedTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredByPinnedTrackers))
            }
        }
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(id: UUID(), name: NSLocalizedString("Pinned", comment: ""), trackers: pinnedTrackers)
            filteredCategories.insert(pinnedCategory, at: 0)
        }
        return filteredCategories
    }

    /// Filters and array of categories to only keep completed trackers with their corresponding categories
    private func filterCompletedTrackers(_ categories: [TrackerCategory]) -> [TrackerCategory] {

        var filteredCategories: [TrackerCategory] = []

        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                return completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
            }

            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredTrackers))
            }
        }
        return filteredCategories
    }

    /// Filters and array of categories to only keep NOT completed trackers with their corresponding categories
    private func filterNotCompletedTrackers(_ categories: [TrackerCategory]) -> [TrackerCategory] {
        var filteredCategories: [TrackerCategory] = []

        for category in categories {
            let filteredTrackers = category.trackers.filter { tracker in
                return !completedRecords.contains { isMatchRecord(model: $0, with: tracker.id) }
            }

            if !filteredTrackers.isEmpty {
                filteredCategories.append(TrackerCategory(id: category.id, name: category.name, trackers: filteredTrackers))
            }
        }
        return filteredCategories
    }

    /// Sets error placeholder visibility depending on the filtered categoried array
    private func setErrorPlaceholderVisibility() {
        if filteredData.isEmpty {
            errorPlaceholderPic.isHidden = false
            errorPlaceholderText.isHidden = false
            placeholderPic.isHidden = true
            placeholderText.isHidden = true
        } else {
            errorPlaceholderPic.isHidden = true
            errorPlaceholderText.isHidden = true
            placeholderPic.isHidden = true
            placeholderText.isHidden = true
        }
    }

    /// Sets error placeholder visibility depending on whether there are any trackers stored un the DataBase
    private func setPlaceholderVisibility() {
        let numberOfTrackers = trackerStore.getNumberOfTrackers()
        if numberOfTrackers == 0 {
            filteredData = []
            errorPlaceholderPic.isHidden = true
            errorPlaceholderText.isHidden = true
            placeholderPic.isHidden = false
            placeholderText.isHidden = false
        }
    }

    /// Sets placeholders' visibility and reloads trackers collection.
    private func updateCollectionView() {
        setPlaceholderVisibility()
        setErrorPlaceholderVisibility()
        trackerCollection.reloadData()
    }
    
    // MARK: - @objc Methods
    
    @objc private func didTapAddButton() {
        
        analyticsService.addTrackerButtonTapped()
        let viewController = CreateTrackerViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc private func didChangeSelectedDate() {
        analyticsService.didSelectDate()
        
        selectedDate = datePicker.date
        
        if let currentFilter = currentFilter {
            switch currentFilter {
            case NSLocalizedString("Completed", comment: ""):
                filteredData = filterCompletedTrackers(getAndFilterTrackersBySelectedDate())
                break
            case NSLocalizedString("Not completed", comment: ""):
                filteredData = filterNotCompletedTrackers(getAndFilterTrackersBySelectedDate())
                break
            default:
                break
            }
        } else {
            filteredData = getAndFilterTrackersBySelectedDate()
        }
        
        updateCollectionView()
    }
    
    @objc private func didTapFiltersButton() {
        analyticsService.didOpenFiltersMenu()
        let viewController = FiltersViewController()
        viewController.delegate = self
        if let currentFilter = currentFilter {
            if currentFilter == NSLocalizedString("Completed", comment: "") || currentFilter == NSLocalizedString("Not completed", comment: "") {
                viewController.currentFilter = currentFilter
            }
        }
        self.present(viewController, animated: true)
    }
    
    @objc func endEditing() {
        searchController.searchBar.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

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

// MARK: - UICollectionViewDelegateFlowLayout

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

// MARK: - FiltersViewControllerDelegate

extension TrackersViewController: FiltersViewControllerDelegate {
    
    func didSelectFilter(_ filter: String) {
        currentFilter = filter
        switch filter {
        case NSLocalizedString("All trackers", comment: ""):
            filteredData = getAndFilterTrackersBySelectedDate()
            setErrorPlaceholderVisibility()
            updateCollectionView()
            break
        case NSLocalizedString("Trackers for today", comment: ""):
            datePicker.date = Date()
            selectedDate = datePicker.date
            filteredData = getAndFilterTrackersBySelectedDate()
            updateCollectionView()
            break
        case NSLocalizedString("Completed", comment: ""):
            filteredData = filterCompletedTrackers(getAndFilterTrackersBySelectedDate())
            updateCollectionView()
            break
        case NSLocalizedString("Not completed", comment: ""):
            filteredData = filterNotCompletedTrackers(getAndFilterTrackersBySelectedDate())
            updateCollectionView()
            break
        default:
            break
        }
    }
    
    func didDeselectFilter() {
        self.currentFilter = nil
        filteredData = getAndFilterTrackersBySelectedDate()
        updateCollectionView()
    }
}

// MARK: - CreateNewHabitViewControllerDelegate

extension TrackersViewController: CreateNewHabitViewControllerDelegate {
    func createdNewHabit() {
        self.didCreateNewTracker()
    }
    
    func cancelNewHabitCreation() {
        
    }
}

// MARK: - UISearchResultsUpdating

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        analyticsService.didAttemptSearching()
        
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
                filteredData = getAndFilterTrackersBySelectedDate()
            }
        } else {
            filteredData = getAndFilterTrackersBySelectedDate()
        }
        updateCollectionView()
    }
}

// MARK: - TrackerCollectionViewCellDelegate

extension TrackersViewController: TrackerCollectionViewCellDelegate {
    
    func markComplete(with id: UUID) {

        analyticsService.didCompleteTracker()
        guard selectedDate <= Date() else {
            return
        }
        trackerRecordStore.saveTrackerRecordCoreData(TrackerRecord(trackerId: id, date: selectedDate))
        completedRecords = trackerRecordStore.getCompletedTrackers()
        updateCollectionView()
    }

    func undoMarkComplete(with id: UUID) {
        
        analyticsService.didUndoCompleteTracker()
        guard selectedDate <= Date() else {
            return
        }
        if completedRecords.contains(where: { $0.trackerId == id && Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .day)}) {
            trackerRecordStore.deleteTrackerRecord(with: id, on: selectedDate)
        }
        completedRecords = trackerRecordStore.getCompletedTrackers()
        updateCollectionView()
    }
    
    func pinTracker(withId id: UUID) {
        
        analyticsService.didPinTracker()
        trackerStore.pinTracker(withId: id)
        self.completedRecords = self.trackerRecordStore.getCompletedTrackers()
        filteredData = getAndFilterTrackersBySelectedDate()
        updateCollectionView()
    }

    func deleteTracker(withId id: UUID) {
        
        analyticsService.didAttemptDeletingTracker()
        let actionSheet: UIAlertController = {
            let alert = UIAlertController()
            alert.title = NSLocalizedString("Delete category confirmation", comment: "")
            return alert
        }()
        let action1 = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) {_ in
            self.analyticsService.didDeleteTracker()
            self.trackerStore.deleteTracker(withId: id)
            self.completedRecords = self.trackerRecordStore.getCompletedTrackers()
            self.filteredData = self.getAndFilterTrackersBySelectedDate()
            self.updateCollectionView()
        }
        let action2 = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) {_ in
            self.analyticsService.didCancelTrackerDeletion()
        }
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        present(actionSheet, animated: true)
    }

    func editTracker(withId id: UUID) {
        
        analyticsService.didPressEditTracker()
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

// MARK: - CreateTrackerViewControllerDelegate

extension TrackersViewController: CreateTrackerViewControllerDelegate {
    
    func didCreateNewTracker() {
        
        filteredData = getAndFilterTrackersBySelectedDate()
        updateCollectionView()
    }
}
