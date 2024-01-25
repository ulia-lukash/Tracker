//
//  CustomView.swift
//  Tracker
//
//  Created by Uliana Lukash on 18.01.2024.
//

import Foundation
import UIKit

final class CustomView: UIView {
        
    private lazy var innerRect: UIView = {
        let innerRect = UIView()
        innerRect.backgroundColor = UIColor(named: "White")
        innerRect.clipsToBounds = true
        innerRect.layer.cornerRadius = 15
        innerRect.backgroundColor = .white
        return innerRect
    }()
    
    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        return label
    }()
    private lazy var statsNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIColor(named: "Black")
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUp()
    }
    
    func updateView(number: String, name: String) {
        statsNameLabel.text = name
        statsLabel.text = number
    }
    
    private func setUp() {
        
        clipsToBounds = true
        layer.cornerRadius = 16
        setGradientBackground()
        
        addSubview(innerRect)
        innerRect.addSubview(statsLabel)
        innerRect.addSubview(statsNameLabel)
        
        innerRect.translatesAutoresizingMaskIntoConstraints = false
        statsLabel.translatesAutoresizingMaskIntoConstraints = false
        statsNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            innerRect.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            innerRect.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            innerRect.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
            innerRect.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            statsLabel.leadingAnchor.constraint(equalTo: innerRect.leadingAnchor, constant: 11),
            statsLabel.topAnchor.constraint(equalTo: innerRect.topAnchor, constant: 11),
            statsLabel.heightAnchor.constraint(equalToConstant: 41),
            statsNameLabel.leadingAnchor.constraint(equalTo: innerRect.leadingAnchor, constant: 11),
            statsNameLabel.topAnchor.constraint(equalTo: statsLabel.bottomAnchor, constant: 7),
            statsNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
        ])
    }
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(named: "Color selection 1")!.cgColor, UIColor(named: "Color selection 9")!.cgColor, UIColor(named: "Color selection 3")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
