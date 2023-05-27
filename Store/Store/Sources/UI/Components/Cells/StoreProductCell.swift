//
//  StoreProductCell.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import Core
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
    
    
    lazy private var promoLabel: UILabel = {
        let label = CorePaddedLabel()
        let padding: CGFloat = 4
        label.padding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = "PROMO"
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.backgroundColor = .systemGray5
        label.textColor = .systemGray
        label.layoutIfNeeded()

        return label
    }()
    
    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 1
        label.text = "placeholder"
        return label
    }()
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = "R$000.00"
        return label
    }()
    
    lazy private var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.numberOfLines = 1
        label.text = "R$000.00"
        return label
    }()
    
    lazy private var tagsStack: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = "PROMO"
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
        contentView.addSubview(promoLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 160),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            promoLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            promoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            promoLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: promoLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            discountLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            discountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            discountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
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
        nameLabel.text = product.name
        priceLabel.text = product.regularPrice
        discountLabel.text = product.actualPrice
        
        discountLabel.isHidden = !product.onSale
        promoLabel.isHidden = !product.onSale
        
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
