//
//  StoreProductCell.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import SDWebImage
import UIKit

class StoreProductCell: UICollectionViewCell {
    
    // MARK: - PUBLIC PROPERTIES
    
    static let cellReuseIdentifier = "StoreProductCellReuseIdentifier"
    var subscribers: Set<AnyCancellable> = []
    let tapAddToCartButton: PassthroughSubject<StoreProductCell, Never> = .init()
    let tapView: PassthroughSubject<StoreProduct?, Never> = .init()
    
    // MARK: - PRIVATE PROPERTIES

    private var product: StoreProduct?

    // MARK: - UI
    
    lazy private var productImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.image = .init(systemName: "tshirt.fill")
        return image
    }()
    
    lazy private var nameView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add to cart", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAddToCartButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - INITIALIZERS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewHierarchy()
        setupConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Localization.Generic.Coder.fatalError)
    }
    
    // MARK: - LIFE CYCLE
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscribers.removeAll()
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameView)
        contentView.addSubview(addToCartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            
            nameView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            nameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameView.bottomAnchor.constraint(equalTo: productImageView.bottomAnchor),
            nameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            
            addToCartButton.centerXAnchor.constraint(equalTo: nameView.centerXAnchor),
            addToCartButton.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(sender:)))
        addGestureRecognizer(gesture)
    }
    
    // MARK: - PUBLIC METHODS
    
    public func setup(product: StoreProduct) {
        self.product = product
        nameView.text = product.name
        if let url = URL(string: product.image) {
            productImageView.sd_setImage(with: url)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
    @objc private func didTapView(sender: UIButton) {
        tapView.send(product)
    }
    
    @objc private func didTapAddToCartButton(sender: UIButton) {
        tapAddToCartButton.send(self)
    }
}
