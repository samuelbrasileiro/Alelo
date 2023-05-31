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
import UIView_Shimmer

class StoreProductCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    static let cellReuseIdentifier = Localization.Components.Cells.Product.cellReuseIdentifier
    var subscribers: Set<AnyCancellable> = []
    let tapAddToCartButton: PassthroughSubject<StoreProduct?, Never> = .init()
    let tapView: PassthroughSubject<StoreProduct?, Never> = .init()
    var shimmeringAnimatedItems: [UIView] {
        [
            productImageView,
            nameLabel,
            priceLabel,
            promoLabel,
            installmentsLabel
        ]
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private var product: StoreProduct?
    
    // MARK: - UI
    
    lazy var productImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 4
        image.image = CoreImage.unavailableImage.image
        return image
    }()
    
    
    lazy var promoLabel: UILabel = {
        let label = CorePaddedLabel()
        let padding: CGFloat = 4
        label.padding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.text = Localization.Components.Cells.Product.PromoLabel.text
        label.backgroundColor = .label
        label.textColor = .systemBackground
        label.layoutIfNeeded()

        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 1
        label.text = Localization.Components.Cells.Product.NameLabel.placeholder
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = Localization.Components.Cells.Product.PriceLabel.placeholder
        return label
    }()
    
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = Localization.Components.Cells.Product.DiscountLabel.placeholder
        label.isHidden = true
        return label
    }()
    
    lazy var discountPercentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .red
        label.numberOfLines = 1
        label.text = Localization.Components.Cells.Product.DiscountPercentageLabel.placeholder
        label.isHidden = true
        return label
    }()
    
    lazy var installmentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = Localization.Components.Cells.Product.InstallsmentsLabel.placeholder
        return label
    }()

    lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "cart.badge.plus"), for: .normal)
        button.backgroundColor = .label
        button.tintColor = .systemBackground
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: #selector(didTapAddToCartButton(sender:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    lazy var sizesStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 8
        return stack
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
        contentView.addSubview(discountPercentageLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountLabel)
        contentView.addSubview(installmentsLabel)
        contentView.addSubview(sizesStack)
        contentView.addSubview(addToCartButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 160),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            
            addToCartButton.centerYAnchor.constraint(equalTo: productImageView.bottomAnchor),
            addToCartButton.leadingAnchor.constraint(greaterThanOrEqualTo: discountPercentageLabel.trailingAnchor, constant: 8),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalTo: addToCartButton.heightAnchor),
            
            promoLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            promoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            discountPercentageLabel.topAnchor.constraint(equalTo: promoLabel.topAnchor),
            discountPercentageLabel.bottomAnchor.constraint(equalTo: promoLabel.bottomAnchor),
            discountPercentageLabel.leadingAnchor.constraint(equalTo: promoLabel.trailingAnchor, constant: 8),
            discountPercentageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: promoLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            discountLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            discountLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            installmentsLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 4),
            installmentsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            installmentsLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            sizesStack.topAnchor.constraint(equalTo: installmentsLabel.bottomAnchor, constant: 4),
            sizesStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sizesStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        addGestureRecognizer(gesture)
    }
    
    // MARK: - PUBLIC METHODS
    
    public func setup(product: StoreProduct) {
        self.product = product
        nameLabel.text = product.name
        priceLabel.text = product.actualPrice
        installmentsLabel.text = product.installments
        
        discountLabel.isHidden = !product.onSale
        promoLabel.isHidden = !product.onSale
        discountPercentageLabel.isHidden = !product.onSale
        addToCartButton.isHidden = false
        
        setSizes(sizes: product.sizes)
        
        if product.onSale {
            setDiscountPrice(value: product.regularPrice)
            discountPercentageLabel.text = product.discountPercentage
        }
        productImageView.sd_setImage(with: URL(string: product.image), placeholderImage: CoreImage.unavailableImage.image)
    }
    
    // MARK: - ACTIONS
    
    @objc func didTapView() {
        tapView.send(product)
    }
    
    @objc func didTapAddToCartButton(sender: UIButton) {
        tapAddToCartButton.send(product)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setDiscountPrice(value: String) {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: value)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        discountLabel.attributedText = attributeString
    }
    
    private func setSizes(sizes: [StoreSize]) {
        sizesStack.removeAllArrangedSubviews()
        for size in sizes where size.available {
            let label = CorePaddedLabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            label.text = size.size
            label.font = .systemFont(ofSize: 10, weight: .thin)
            label.layer.cornerRadius = 4
            label.layer.masksToBounds = true
            label.backgroundColor = .systemBackground
            label.textColor = .label
            label.layer.borderColor = UIColor.label.cgColor
            label.layer.borderWidth = 0.2
            sizesStack.addArrangedSubview(label)
        }
    }
}
