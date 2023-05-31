//
//  StoreValueConfirmationView.swift
//  Store
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import Combine
import UIKit

class StoreValueConfirmationView: UIView {
    
    // MARK: - PUBLIC PROPERTIES
    
    let tapCompleteButton: PassthroughSubject<Void, Never> = .init()

    var disabled = false {
        didSet {
            changeVisibility()
        }
    }
    
    // MARK: - UI
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.text = Localization.Components.Views.ValueConfirmation.DescriptionLabel.placeholder
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.numberOfLines = 1
        label.text = Localization.Components.Views.ValueConfirmation.PriceLabel.placeholder
        return label
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitle(Localization.Components.Views.ValueConfirmation.CompleteButton.placeholder, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 32, bottom: 8, right: 32)
        button.addTarget(self, action: #selector(didTapCompleteButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - INITIALIZERS
    
    public init() {
        super.init(frame: .zero)
        
        setupViewHierarchy()
        setupConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Localization.Generic.Coder.fatalError)
    }
    
    // MARK: - LIFE CYCLE
    
    private func setupViewHierarchy() {
        addSubview(descriptionLabel)
        addSubview(priceLabel)
        addSubview(completeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            completeButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            completeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: completeButton.topAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: completeButton.trailingAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),
            
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor)
            

        ])
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
    }
    
    // MARK: - PUBLIC METHODS
    
    public func setup(descriptionText: String, buttonText: String) {
        descriptionLabel.text = descriptionText
        completeButton.setTitle(buttonText, for: .normal)
    }
    
    public func update(priceText: String) {
        priceLabel.text = priceText
    }
    
    // MARK: - ACTIONS
    
    @objc func didTapCompleteButton(sender: UIButton) {
        tapCompleteButton.send(())
    }
    
    // MARK: - PRIVATE METHODS
    
    private func changeVisibility() {
        let buttonBackgroundColor: UIColor = disabled ? .systemGray4 : .label
        completeButton.backgroundColor = buttonBackgroundColor
        completeButton.isEnabled = !disabled
    }
}
