//
//  Components.swift
//  Tracker
//
//  Created by Uliana Lukash on 25.12.2023.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    var buttonLabel: String?
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.backgroundColor = UIColor(named: "Black")
        self.setTitle(buttonLabel, for: .normal)
        self.tintColor = .white
        self.layer.cornerRadius = 16
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.titleLabel?.textColor = .white
        self.titleLabel?.textAlignment = .center
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

class CustomTextField: UITextField {
//    var startingString: String?
    
    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        button.tintColor = UIColor(named: "Gray")
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 17),
            button.heightAnchor.constraint(equalToConstant: 17)
        ])
        button.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
//        self.text = startingString
        self.backgroundColor = UIColor(named: "Background")
        self.textColor = UIColor(named: "Black")
        self.layer.cornerRadius = 16
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        self.leftViewMode = .always
        self.clearButtonMode = .whileEditing
        self.addSubview(clearButton)
        
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            clearButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            clearButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12)
        ])
    }
    
    @objc private func clearButtonTapped() {
        delete(self.text)
    }
}
