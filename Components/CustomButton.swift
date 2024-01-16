//
//  Components.swift
//  Tracker
//
//  Created by Uliana Lukash on 25.12.2023.
//

import Foundation
import UIKit

final class CustomButton: UIButton {
    
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
        clipsToBounds = true
        backgroundColor = UIColor(named: "Black")
        titleLabel?.tintColor =  UIColor(named: "White")
        setTitle(buttonLabel, for: .normal)

        layer.cornerRadius = 16
        titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel?.textAlignment = .center
        heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

