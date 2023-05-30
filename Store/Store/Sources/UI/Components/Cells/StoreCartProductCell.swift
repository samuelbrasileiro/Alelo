//
//  StoreCartProductCell.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Combine
import Core
import SDWebImage
import UIKit
import UIView_Shimmer

class StoreCartProductCell: UITableViewCell, ShimmeringViewProtocol {
    
    // MARK: - PUBLIC PROPERTIES
    
    static let cellReuseIdentifier = "StoreCartProductCellReuseIdentifier"
    var subscribers: Set<AnyCancellable> = []
    let tapUpdateCartButton: PassthroughSubject<StoreCartProduct?, Never> = .init()
    let tapView: PassthroughSubject<StoreProduct?, Never> = .init()
    var shimmeringAnimatedItems: [UIView] {
        [
            productImageView,
            nameLabel,
            priceLabel,
        ]
    }
    
    // MARK: - PRIVATE PROPERTIES
    
    private var product: StoreCartProduct?
    
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
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 2
        label.text = "placeholder"
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = "R$000.00"
        return label
    }()
    
    lazy var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = "R$000.00"
        label.isHidden = true
        return label
    }()
    
    lazy var sizeLabel: UILabel = {
        let label = CorePaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        label.font = .systemFont(ofSize: 10, weight: .thin)
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.layer.borderColor = UIColor.label.cgColor
        label.layer.borderWidth = 0.2
        return label
    }()

    lazy var countStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.addTarget(self, action: #selector(stepperDidChange), for: .valueChanged)
        return stepper
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "0 ITEM"
        return label
    }()
    
    // MARK: - INITIALIZERS
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(discountLabel)
        contentView.addSubview(countStepper)
        contentView.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),

            sizeLabel.topAnchor.constraint(greaterThanOrEqualTo: nameLabel.bottomAnchor, constant: 8),
            sizeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            discountLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            discountLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            countStepper.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            countStepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            countStepper.widthAnchor.constraint(equalToConstant: 100),
            countStepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            countLabel.leadingAnchor.constraint(equalTo: countStepper.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: countStepper.trailingAnchor),
            countLabel.bottomAnchor.constraint(equalTo: countStepper.topAnchor, constant: -8)
        ])
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(sender:)))
        addGestureRecognizer(gesture)
    }
    
    // MARK: - PUBLIC METHODS
    
    public func setup(product: StoreCartProduct) {
        self.product = product
        nameLabel.text = product.item.name
        priceLabel.text = product.item.actualPrice
        
        discountLabel.isHidden = !product.item.onSale
        
        sizeLabel.text = product.chosenSize.size
        countStepper.value = Double(product.quantity)
        setCountLabel(value: product.quantity)
        
        if product.item.onSale {
            setDiscountPrice(value: product.item.regularPrice)
        }
        productImageView.sd_setImage(with: URL(string: product.item.image), placeholderImage: CoreImage.unavailableImage.image)
    }
    
    // MARK: - ACTIONS
    
    @objc func stepperDidChange(sender: UIStepper) {
        product?.quantity = Int(sender.value)
        setCountLabel(value: Int(sender.value))
        tapUpdateCartButton.send(product)
        if Int(countStepper.value) == 0 {
            let minimum = 1
            product?.quantity = minimum
            sender.value = Double(minimum)
            setCountLabel(value: minimum)
        }
    }
    
    @objc func didTapView(sender: UIButton) {
        tapView.send(product?.item)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setDiscountPrice(value: String) {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: value)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        discountLabel.attributedText = attributeString
    }
    
    private func setCountLabel(value: Int) {
        let countText: String
        if value > 1 {
            countText = "\(value) ITENS"
        } else {
            countText = "\(value) ITEM"
        }
        countLabel.text = countText
    }
}
