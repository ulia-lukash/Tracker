//
//  CustomTextField.swift
//  Tracker
//
//  Created by Uliana Lukash on 10.01.2024.
//

import Foundation
import UIKit

final class CustomTextField: UITextField {
    
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
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setup() {
        clipsToBounds = true
        backgroundColor = UIColor(named: "Background")
        textColor = UIColor(named: "Black")
        layer.cornerRadius = 16
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: self.frame.height))
        leftViewMode = .always
        clearButtonMode = .whileEditing
        addSubview(clearButton)
        
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
