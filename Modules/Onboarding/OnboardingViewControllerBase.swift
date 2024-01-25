//
//  OnboardingViewControllerBase.swift
//  Tracker
//
//  Created by Uliana Lukash on 10.01.2024.
//

import Foundation
import UIKit

final class OnboardingViewControllerBase: UIViewController {
    
    private let imageName: String?
    private let labelText: String?
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var label: UILabel = {
        let label = UILabel()
        label.text = labelText
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    lazy private var button: CustomButton = {
        let button = CustomButton()
        button.buttonLabel = NSLocalizedString("Wow technology", comment: "")
        return button
    }()
    
    init(imageName: String?, labelText: String?) {
        self.imageName = imageName
        self.labelText = labelText
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setUp() {
        
        button.addTarget(self, action: #selector(didTapOnboardingButton), for: .touchUpInside)
        imageView.image = UIImage(named: imageName!)
        
        view.addSubview(button)
        view.addSubview(label)
        view.insertSubview(imageView, at: 0)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func didTapOnboardingButton() {
        let viewController = TabBarViewController()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "SkippedUnboarding")
        defaults.set(Date(), forKey: "FirstDayOfUsage")
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
        
    }
}
