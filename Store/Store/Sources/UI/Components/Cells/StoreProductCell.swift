//
//  StoreProductCell.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import SDWebImage
import UIKit

class StoreProductCell: UITableViewCell {
    static let cellReuseIdentifier = "StoreProductCellReuseIdentifier"
    
    private var product: StoreProduct?
    
    var subscribers: Set<AnyCancellable> = []
    
    let tapRemoveButton: PassthroughSubject<StoreProductCell, Never> = .init()
    let tapView: PassthroughSubject<StoreProduct?, Never> = .init()
    
    lazy private var productImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        image.image = .init(systemName: "person.circle.fill")
        return image
    }()
    
    lazy private var nameView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 27, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.init(systemName: "multiply.circle.fill"),
                        for: .normal)
        button.addTarget(self, action: #selector(didTapRemoveButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViewHierarchy()
        setupConstraints()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError(Localization.Generic.Coder.fatalError)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subscribers.removeAll()
    }
    
    private func setupViewHierarchy() {
        contentView.addSubview(productImageView)
        contentView.addSubview(nameView)
        contentView.addSubview(removeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productImageView.widthAnchor.constraint(equalToConstant: 30),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            productImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: 8),
            productImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            nameView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            nameView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalTo: removeButton.widthAnchor),
            removeButton.leadingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: 8),
            removeButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(sender:)))
        addGestureRecognizer(gesture)
    }
    
    public func setup(product: StoreProduct) {
        self.product = product
        nameView.text = product.name
        if let url = URL(string: product.image) {
            productImageView.sd_setImage(with: url)
        }
    }
    
    @objc private func didTapView(sender: UIButton) {
        tapView.send(product)
    }
    
    @objc private func didTapRemoveButton(sender: UIButton) {
        tapRemoveButton.send(self)
    }
}
