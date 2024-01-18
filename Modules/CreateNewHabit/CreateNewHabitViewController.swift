//
//  CreateNewHabitViewController.swift
//  Tracker
//
//  Created by Uliana Lukash on 05.12.2023.
//

import Foundation
import UIKit

protocol CreateNewHabitViewControllerDelegate: AnyObject {
    func createdNewHabit()
    func cancelNewHabitCreation()
}

class CreateNewHabitViewController: UIViewController {
    
    // MARK: - Public Properties
    
    weak var delegate: CreateNewHabitViewControllerDelegate?
    var isHabit: Bool = true
    var isEdit: Bool = false
    var tracker: TrackerCoreData?
    
    // MARK: - Private Properties
    
    private let trackerStore = TrackerStore.shared
    private let categoryStore = TrackerCategoryStore.shared
    private let recordStore = TrackerRecordStore.shared
    
    private let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    private let colours = {
        var coloursArray: Array<UIColor> = []
        
        for i in 1...18 {
            let colourName = "Color selection " + String(i)
            let colour = UIColor(named: colourName)
            coloursArray.append(colour!)
        }
        return coloursArray
    }()
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    private lazy var headerView = UIView()
    
    private let scrollViewContent = UIView()
    private var settings: Array<SettingOptions> = []
    private var configuredSchedule: Set<WeekDays> = [.monday, .tuesday, .wednesday, .thursday, .friday, .sunday, .saturday]
    private var pickedCategory: TrackerCategory?
    private var pickedEmoji: String?
    private var pickedColour: UIColor?
    
    private lazy var scrollView = UIScrollView()
    private lazy var viewTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var restrictionLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Name length restriction", comment: "")
        label.font = .systemFont(ofSize: 17)
        label.textColor = UIColor(named: "Red")
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textFieldView = UIView()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(named: "Background")
        textField.textColor = UIColor(named: "Black")
        textField.placeholder = NSLocalizedString("Input tracker name", comment: "")
        textField.layer.cornerRadius = 16
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
        
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .allEditingEvents)
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        cancelButton.layer.borderColor = UIColor(named: "Red")!.cgColor
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        cancelButton.layer.cornerRadius = 16
        return cancelButton
    }()
    
    private lazy var settingTable: UITableView = {
        let table = UITableView(frame: .zero)
        
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        if isHabit {
            table.heightAnchor.constraint(equalToConstant: 150).isActive = true
        } else {
            table.heightAnchor.constraint(equalToConstant: 75).isActive = true
        }
        
        return table
    }()
    
    private lazy var emojisCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(EmojisCollectionViewCell.self, forCellWithReuseIdentifier: EmojisCollectionViewCell.identifier)
        collection.register(EmojisCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.isScrollEnabled = false
        collection.layer.masksToBounds = true
        collection.heightAnchor.constraint(equalToConstant: 230).isActive = true
        return collection
    }()
    
    private lazy var coloursCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collection.register(ColoursCollectionViewCell.self, forCellWithReuseIdentifier: ColoursCollectionViewCell.identifier)
        collection.register(ColoursCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collection.isScrollEnabled = false
        collection.layer.masksToBounds = true
        collection.heightAnchor.constraint(equalToConstant: 256).isActive = true
        
        return collection
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton()
        createButton.backgroundColor = UIColor(named: "Gray")
        createButton.setTitleColor(UIColor(named: "White"), for: .normal)
        createButton.layer.cornerRadius = 16
        return createButton
    }()
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        
        settingTable.dataSource = self
        settingTable.delegate = self
        
        emojisCollection.dataSource = self
        emojisCollection.delegate = self
        
        coloursCollection.dataSource = self
        coloursCollection.delegate = self
        
        appendSettingsToList()
        view.backgroundColor = UIColor(named: "White")
        
        configView()
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        
        createButton.setTitle( isEdit ? NSLocalizedString("Save", comment: "") : NSLocalizedString("Create", comment: ""), for: .normal)
    }
    
    // MARK: - Private Methods
    private func configureLabels() {
        if isEdit {
            viewTitle.text = NSLocalizedString("Edit tracker", comment: "")
            if let trackerCoreData = self.tracker {
                let trackerToedit = trackerStore.convertToTracker(coreDataTracker: trackerCoreData)
                textField.text = trackerToedit.name
                pickedEmoji = trackerToedit.emoji
                pickedColour = trackerToedit.colour
                
                let category = categoryStore.transformCoreDatacategory(trackerCoreData.category!)
                pickedCategory = category
                
                let records = recordStore.fetchCompletedRecordsForTracker(trackerCoreData)
                let count = records.count
                
                let key = "number_of_days"
                let localizationFormat = NSLocalizedString(key, tableName: key, comment: "Days counter label")
                let days = String(format: localizationFormat, count)
                counterLabel.text = days
            }
        } else {
            viewTitle.text = isHabit ? NSLocalizedString("New habit", comment: "") : NSLocalizedString("New irregular action", comment: "")
        }
    }
    
    private func appendSettingsToList() {
        
        settings.append(
            SettingOptions(
                name: NSLocalizedString("Category", comment: ""),
                pickedParameter: isEdit ? pickedCategory?.name : nil,
                handler: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.setCategory()
                }
            ))
        if isHabit {
            settings.append(
                SettingOptions(
                    name: NSLocalizedString("Schedule", comment: ""),
                    pickedParameter: nil,
                    handler: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.setSchedule()
                    }
                ))
            if isEdit {
                didConfigure(schedule: (tracker?.schedule!.schedule)!)
            }
        }
        
    }
    
    private func setCategory() {
        let setCategoryController = SetCategoryViewController()
        setCategoryController.viewModelDelegate = self
        
        present(UINavigationController(rootViewController: setCategoryController), animated: true)
    }
    
    private func setSchedule() {
        let setScheduleController = SetScheduleViewController()
        setScheduleController.delegate = self
        present(UINavigationController(rootViewController: setScheduleController), animated: true)
    }
    
    private func configView(){
        
        restrictionLabel.isHidden = true
        
        setUpHeader()
        setUpScrollViewContent()
        
        view.addSubview(scrollView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        scrollView.addSubview(scrollViewContent)
        
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContent.heightAnchor.constraint(equalToConstant: 800),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    private func setUpScrollViewContent() {
                        
        scrollViewContent.addSubview(textField)
        scrollViewContent.addSubview(restrictionLabel)
        scrollViewContent.addSubview(settingTable)
        scrollViewContent.addSubview(emojisCollection)
        scrollViewContent.addSubview(coloursCollection)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        restrictionLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        settingTable.translatesAutoresizingMaskIntoConstraints = false
        emojisCollection.translatesAutoresizingMaskIntoConstraints = false
        coloursCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: scrollViewContent.topAnchor),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor),
            textField.textInputView.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 16),
            
            restrictionLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            restrictionLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 28),
            restrictionLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -28),
            settingTable.topAnchor.constraint(equalTo: restrictionLabel.bottomAnchor, constant: 24),
            settingTable.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor),
            settingTable.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor),
            
            emojisCollection.topAnchor.constraint(equalTo: settingTable.bottomAnchor, constant: 32),
            emojisCollection.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 2),
            emojisCollection.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -2),
            
            coloursCollection.topAnchor.constraint(equalTo: emojisCollection.bottomAnchor, constant: 16),
            coloursCollection.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 2),
            coloursCollection.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -2),
        ])
    }
    
    private func setUpHeader() {
        
        let headerViewHeight: CGFloat = isEdit ? 124 : 68
        view.addSubview(headerView)
        
        headerView.addSubview(viewTitle)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        viewTitle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            viewTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            viewTitle.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 30),
            viewTitle.heightAnchor.constraint(equalToConstant: 22),
            
        ])
        
        if isEdit {
            
            headerView.addSubview(counterLabel)
            counterLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                counterLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                counterLabel.topAnchor.constraint(equalTo: viewTitle.bottomAnchor, constant: 24),
            ])
        }
        
        headerView.heightAnchor.constraint(equalToConstant: headerViewHeight).isActive = true
        }
        
    // MARK: - @objc Methods
    
    @objc private func didTapCancelButton() {
        dismiss(animated: false)
        delegate?.cancelNewHabitCreation()
    }
    
    @objc private func didTapCreateButton() {
        dismiss(animated: false)
        if !isEdit {
            guard let trackerName = textField.text, let pickedCategory = pickedCategory else { return }
            
            guard let colour = pickedColour, let emoji = pickedEmoji else { return }
            
            let newHabit = Tracker(id: UUID(), name: trackerName, colour: colour, emoji: emoji, schedule: configuredSchedule, isPinned: false)
            
            trackerStore.saveTrackerCoreData(newHabit, toCategory: pickedCategory)
            
            
        } else {
            guard let coreDataTracker = tracker else { return }
            
            guard let name = textField.text, let colour = pickedColour, let emoji = pickedEmoji else { return }
            let newTracker = Tracker(id: UUID(), name: name, colour: colour, emoji: emoji, schedule: configuredSchedule, isPinned: coreDataTracker.isPinned)
            
            trackerStore.editTracker(withId: coreDataTracker.id!, tracker: newTracker, category: pickedCategory!)
        }
        delegate?.createdNewHabit()
    }
    
    @objc private func setCreateButtonState() {
        guard let habitName = textField.text, let pickedEmoji = pickedEmoji else {
            return
        }
        
        if habitName.isEmpty || pickedEmoji.isEmpty || pickedColour == nil || pickedCategory == nil || configuredSchedule.isEmpty && isHabit  {
            createButton.backgroundColor = UIColor(named: "Gray")
            createButton.isEnabled = false
        } else {
            createButton.backgroundColor = UIColor(named: "Black")
            createButton.isEnabled = true
        }
    }
    
    @objc private func textFieldDidChange() {
        if textField.text!.count >= 38 {
            
            restrictionLabel.isHidden = false
        } else {
            
            restrictionLabel.isHidden = true
            
        }
        setCreateButtonState()
    }
}

extension CreateNewHabitViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "SettingTableViewCell"
        
        let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
        
        cell!.textLabel?.text = settings[indexPath.row].name
        cell!.detailTextLabel?.text = settings[indexPath.row].pickedParameter
        
        return cell!
        
    }
}

extension CreateNewHabitViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
}

extension CreateNewHabitViewController: SetScheduleViewControllerDelegate {
    
    func didConfigure(schedule: Set<WeekDays>) {
        configuredSchedule = schedule
        let scheduleArraySorted = schedule.sorted(by: {$0.rawValue < $1.rawValue})
        var scheduleStringArray: [String] = []
        for day in scheduleArraySorted {
            switch day {
            case .monday:
                scheduleStringArray.append("Пн")
            case .tuesday:
                scheduleStringArray.append("Вт")
            case .wednesday:
                scheduleStringArray.append("Ср")
            case .thursday:
                scheduleStringArray.append("Чт")
            case .friday:
                scheduleStringArray.append("Пт")
            case .saturday:
                scheduleStringArray.append("Сб")
            case .sunday:
                scheduleStringArray.append("Вс")
            }
        }
        
        let scheduleString = scheduleStringArray.joined(separator: ", ")
        settings[1].pickedParameter = scheduleString
        settingTable.reloadData()
        setCreateButtonState()
        dismiss(animated: true)
    }
}

extension CreateNewHabitViewController: SetCategoryViewControllerDelegate {
    func didSetCategory(category: TrackerCategory) {
        setCreateButtonState()
        pickedCategory = category
        settings[0].pickedParameter = category.name
        settingTable.reloadData()
    }
}

extension CreateNewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojisCollection {
            return emojis.count
        } else {
            return colours.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojisCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojisTableCell", for: indexPath) as? EmojisCollectionViewCell
            
            cell?.titleLabel.text = emojis[indexPath.row]
            if isEdit {
                if emojis[indexPath.row] == pickedEmoji {
                    
                    self.emojisCollection.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell?.isSelected = true
                }
            }
            return cell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coloursTableCell", for: indexPath) as? ColoursCollectionViewCell
            
            cell?.titleLabel.backgroundColor = colours[indexPath.row]
            if isEdit {
                if colours[indexPath.row] == pickedColour {
                    
                    self.coloursCollection.selectItem(at: indexPath, animated: true, scrollPosition: .left)
                    cell?.isSelected = true
                }
            }
            return cell!
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if collectionView == emojisCollection {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! EmojisCollectionHeaderView
            view.titleLabel.text = "Emoji"
            return view
        } else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ColoursCollectionHeaderView
            view.titleLabel.text = NSLocalizedString("Colour", comment: "")
            return view
        }
        
    }
}

extension CreateNewHabitViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollection {
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojisCollectionViewCell {
                cell.pickCell()
                pickedEmoji = emojis[indexPath.row]
                setCreateButtonState()
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColoursCollectionViewCell {
                
                pickedColour = colours[indexPath.row]
                
                let colour = colours[indexPath.row].withAlphaComponent(0.3)
                cell.pickCell(withColour: colour.cgColor)
                setCreateButtonState()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollection {
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojisCollectionViewCell {
                cell.backgroundColor = UIColor(named: "White")
                setCreateButtonState()
            }
        } else {
            if let cell = collectionView.cellForItem(at: indexPath) as? ColoursCollectionViewCell {
                cell.layer.borderColor = UIColor(named: "White")?.cgColor
                setCreateButtonState()
            }
        }
    }
    
}

extension CreateNewHabitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}
