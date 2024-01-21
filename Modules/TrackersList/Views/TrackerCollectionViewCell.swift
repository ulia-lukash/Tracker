//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Uliana Lukash on 26.11.2023.
//

import Foundation
import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    
    func markComplete(with id: UUID)
    func undoMarkComplete(with id: UUID)
    func deleteTracker(withId id: UUID)
    func pinTracker(withId id: UUID)
    func editTracker(withId id: UUID)
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "cell"
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    
    private let analyticsService = AnalyticsService.shared
    private var isPinned: Bool = false
    private var trackerStore = TrackerStore.shared
    private var trackerId: UUID?
    private var indexPath: IndexPath?
    private var isCompleted: Bool?
    private lazy var backgroundRect: UIView = {
        let view = UIView()
        let interaction = UIContextMenuInteraction(delegate: self)
        view.addInteraction(interaction)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(named: "White")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Background")
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        return view
    }()
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor(named: "Black")
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private lazy var markCompleteButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.tintColor = UIColor(named: "White")
        button.addTarget(self, action: #selector(incrementCounter), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var pinIcon: UIImageView = {
        let imageview = UIImageView()
        let image = UIImage(systemName: "pin.fill")
        imageview.image = image?.withAlignmentRectInsets(UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6))
        imageview.tintColor = .white
        return imageview
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(model: Tracker, at indexPath: IndexPath, isCompleted: Bool, completedDays: Int) {
        
        self.trackerId = model.id
        self.isPinned = model.isPinned
        self.indexPath = indexPath
        self.isCompleted = isCompleted
        
        nameLabel.text = model.name
        configureCounter(days: completedDays)
        
        let image = isCompleted ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus")
        let imageview = UIImageView(image: image)
        
        markCompleteButton.backgroundColor = isCompleted ? model.colour.withAlphaComponent(0.3) : model.colour
        backgroundRect.backgroundColor = model.colour
        for view in self.markCompleteButton.subviews {
            view.removeFromSuperview()
        }
        markCompleteButton.addSubview(imageview)
        
        
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.centerXAnchor.constraint(equalTo: markCompleteButton.centerXAnchor).isActive = true
        imageview.centerYAnchor.constraint(equalTo: markCompleteButton.centerYAnchor).isActive = true
        
        let label = UILabel()
        label.text = model.emoji
        label.font = .systemFont(ofSize: 16, weight: .medium)
        
        for view in self.emojiView.subviews {
            view.removeFromSuperview()
        }
        emojiView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor).isActive = true
        showPin()
    }
    
    // MARK: - Private Methods
    
    private func configureCellLayout() {
        contentView.addSubview(backgroundRect)
        backgroundRect.addSubview(emojiView)
        backgroundRect.addSubview(nameLabel)
        backgroundRect.addSubview(pinIcon)
        
        contentView.addSubview(counterLabel)
        contentView.addSubview(markCompleteButton)
        
        pinIcon.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundRect.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        markCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundRect.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundRect.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundRect.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emojiView.topAnchor.constraint(equalTo: backgroundRect.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: backgroundRect.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: backgroundRect.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: backgroundRect.trailingAnchor, constant: -12),
            counterLabel.centerYAnchor.constraint(equalTo: markCompleteButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            markCompleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            markCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            pinIcon.widthAnchor.constraint(equalToConstant: 24),
            pinIcon.heightAnchor.constraint(equalToConstant: 24),
            pinIcon.topAnchor.constraint(equalTo: backgroundRect.topAnchor, constant: 12),
            pinIcon.trailingAnchor.constraint(equalTo: backgroundRect.trailingAnchor, constant: -4)
        ])
    }
    
    private func showPin() {
        if self.isPinned {
            pinIcon.isHidden = false
        } else {
            pinIcon.isHidden = true
        }
    }
    
    private func configureCounter(days: Int) {
        let key = "number_of_days"
        let localizationFormat = NSLocalizedString(key, tableName: key, comment: "Days counter label")
        let string = String(format: localizationFormat, days)
        counterLabel.text = string
    }
    
    // MARK: - @objc Methods
    
    @objc private func incrementCounter() {
        guard let isCompleted = isCompleted,
              let trackerID = trackerId
        else {
            return
        }
        if isCompleted {
            delegate?.undoMarkComplete(with: trackerID)
        } else {
            delegate?.markComplete(with: trackerID)
            
        }
    }
}

extension TrackerCollectionViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: {
            suggestedActions in
            
            self.analyticsService.didTapTracker()
            
            let pinAction = UIAction(title: self.isPinned ? NSLocalizedString("Unpin", comment: "") : NSLocalizedString("Pin", comment: "")) { action in
                
                guard let trackerId = self.trackerId else { return }
                self.delegate?.pinTracker(withId: trackerId)
                
            }
            
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: "")) { action in
                guard let trackerId = self.trackerId else { return }
                self.delegate?.editTracker(withId: trackerId)
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""), attributes: .destructive) { action in
                
                guard let trackerId = self.trackerId else { return }
                self.delegate?.deleteTracker(withId: trackerId)
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        })
    }
}
