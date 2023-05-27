//
//  CoreBarButtonItem.swift
//  Core
//
//  Created by Samuel Brasileiro on 27/05/23.
//

import UIKit

public class CoreBarButtonItem: UIBarButtonItem {
    
    // MARK: - PRIVATE PROPERTIES
    
    lazy private var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var badgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: - PUBLIC PROPERTIES
    
    public var badgeValue: Int = 0 {
        didSet {
            updateBadge()
        }
    }
    
    // MARK: - INITIALIZERS
    
    public init(image: UIImage?, target: Any?, action: Selector) {
        super.init()
        customView = button
        
        setupViewHierarchy()
        setupConstraints()
        setupView(image: image, target: target, action: action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LIFE CYCLE
    
    private func setupViewHierarchy() {
        button.addSubview(badgeLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            badgeLabel.centerXAnchor.constraint(equalTo: button.trailingAnchor),
            badgeLabel.centerYAnchor.constraint(equalTo: button.topAnchor),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 16),
            badgeLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupView(image: UIImage?, target: Any?, action: Selector) {
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        updateBadge()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func updateBadge() {
        badgeLabel.isHidden = badgeValue <= 0
        badgeLabel.text = "\(badgeValue)"
    }
}
