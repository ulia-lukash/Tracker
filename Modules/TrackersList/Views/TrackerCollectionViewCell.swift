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
    
}

class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "cell"
    weak var delegate: TrackerCollectionViewCellDelegate?
    
    // MARK: - IBOutlet
    
    // MARK: - Private Properties
    
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
        
        label.textColor = UIColor(ciColor: .white)
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
        button.tintColor = UIColor(ciColor: .white)
        button.addTarget(self, action: #selector(incrementCounter), for: .touchUpInside)
        
        return button
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
    }
    
    // MARK: - Private Methods
    
    private func configureCellLayout() {
        contentView.addSubview(backgroundRect)
        backgroundRect.addSubview(emojiView)
        backgroundRect.addSubview(nameLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(markCompleteButton)
        
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
            markCompleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureCounter(days: Int) {
        let localized = NSLocalizedString("number_of_days", comment: "no comment")
//        let formatted = String(format: localized, days)
        counterLabel.text = formatted
//        if (11...14).contains(remainder) {
//            counterLabel.text = "\(days) дней"
//        } else {
//            switch remainder % 10 {
//            case 1:
//                counterLabel.text = "\(days) день"
//            case 2...4:
//                counterLabel.text = "\(days) дня"
//            default:
//                counterLabel.text = "\(days) дней"
//            }
//        }
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
            let pinAction = UIAction(title: "Закрепить") { action in
//                self.performInspect()
            }
            
            let editAction = UIAction(title: "Редактировать") { action in
//                self.performDuplicate()
            }
            
            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { action in
//                self.performDelete()
            }
            
            return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
        })
    }
}
