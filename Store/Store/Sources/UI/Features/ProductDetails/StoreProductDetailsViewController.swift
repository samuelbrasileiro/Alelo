//
//  StoreProductDetailsViewController.swift
//  Store
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import Combine
import Commons
import Core
import UIKit

protocol StoreProductDetailsViewControllerDelegate: AnyObject {
    func storeProductDetailsViewController(_ viewController: StoreProductDetailsViewController, goToCart _: Void)
}

class StoreProductDetailsViewController: UIViewController {
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: StoreProductDetailsViewControllerDelegate?
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: StoreProductDetailsViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI
    
    lazy private var productImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    lazy private var promoLabel: UILabel = {
        let label = CorePaddedLabel()
        let padding: CGFloat = 4
        label.padding = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.text = Localization.Features.ProductDetails.PromoLabel.text
        label.backgroundColor = .label
        label.textColor = .systemBackground
        label.layoutIfNeeded()
        return label
    }()
    
    lazy private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.numberOfLines = 0
        label.text = Localization.Features.ProductDetails.NameLabel.placeholder
        return label
    }()
    
    lazy private var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.numberOfLines = 1
        label.text = Localization.Features.ProductDetails.PriceLabel.placeholder
        return label
    }()
    
    lazy private var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = Localization.Features.ProductDetails.DiscountLabel.placeholder
        label.isHidden = true
        return label
    }()
    
    lazy private var discountPercentageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .light)
        label.textColor = .red
        label.numberOfLines = 1
        label.text = Localization.Features.ProductDetails.DiscountPercentageLabel.placeholder
        label.isHidden = true
        return label
    }()
    
    lazy private var installmentsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = Localization.Features.ProductDetails.InstallsmentsLabel.placeholder
        return label
    }()

    lazy private var addToCartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        button.setTitle(Localization.Features.ProductDetails.AddToCartButton.text, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.addTarget(self, action: #selector(didTapAddToCartButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var sizesStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 8
        return stack
    }()
    
    lazy private var cartButton: CoreBarButtonItem = {
        let button = CoreBarButtonItem(image: .init(systemName: "cart"),
                                       target: self,
                                       action: #selector(didTapCartButton))
        return button
    }()
    
    // MARK: - INITIALIZERS
    
    init(viewModel: StoreProductDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(Localization.Generic.Coder.fatalError)
    }
    
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindObservables()
        setupViewHierarchy()
        setupConstraints()
        setupView()
        viewModel.setup()
    }
    
    private func bindObservables() {
        viewModel.changeViewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                self?.handleViewState(viewState)
            }.store(in: &subscriptions)
        
        viewModel.cartCountViewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                self?.handleCartCountViewState(viewState)
            }.store(in: &subscriptions)
        
        StoreCartObserver.shared.didUpdateCart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                self?.viewModel.retrieveCartCount()
            }.store(in: &subscriptions)
    }
    
    private func setupViewHierarchy() {
        view.addSubview(productImageView)
        view.addSubview(promoLabel)
        view.addSubview(discountPercentageLabel)
        view.addSubview(nameLabel)
        view.addSubview(priceLabel)
        view.addSubview(discountLabel)
        view.addSubview(installmentsLabel)
        view.addSubview(sizesStack)
        view.addSubview(addToCartButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            productImageView.heightAnchor.constraint(equalToConstant: 280),
            productImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            productImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            
            promoLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            promoLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            
            discountPercentageLabel.topAnchor.constraint(equalTo: promoLabel.topAnchor),
            discountPercentageLabel.bottomAnchor.constraint(equalTo: promoLabel.bottomAnchor),
            discountPercentageLabel.leadingAnchor.constraint(equalTo: promoLabel.trailingAnchor, constant: 8),
            discountPercentageLabel.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -24),
            
            nameLabel.topAnchor.constraint(equalTo: promoLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            
            discountLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            discountLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 4),
            discountLabel.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -8),
            
            installmentsLabel.topAnchor.constraint(equalTo: discountLabel.bottomAnchor, constant: 4),
            installmentsLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            installmentsLabel.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -24),
            
            sizesStack.topAnchor.constraint(equalTo: installmentsLabel.bottomAnchor, constant: 4),
            sizesStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            sizesStack.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor, constant: -24),
            
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            addToCartButton.topAnchor.constraint(greaterThanOrEqualTo: sizesStack.bottomAnchor, constant: 16),
            addToCartButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 24),
            addToCartButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -24),
            addToCartButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -24)
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = Localization.Features.ProductDetails.navigationTitle
        navigationItem.setRightBarButton(cartButton, animated: true)
    }
    
    // MARK: - HANDLERS
    
    private func handleViewState(_ viewState: StoreProductDetailsViewState) {
        switch viewState {
        case .success(let product):
            handleSuccess(product)
        case .error(let error):
            handleError(error)
        }
    }

    private func handleSuccess(_ product: StoreProduct) {
        displayProduct(product)
    }
    
    private func handleError(_ error: Error) {
        showError(error)
    }
    
    private func handleCartCountViewState(_ viewState: StoreCartCountViewState) {
        switch viewState {
        case .success(let count):
            setCartCount(count)
        case .error(let error):
            handleError(error)
        }
    }
    
    private func handleAddToCart(size: StoreSize, product: StoreProduct) {
        viewModel.addToCart(size: size, product: product)
    }
    
    // MARK: - ACTIONS
    
    @objc func didTapAddToCartButton(sender: UIButton) {
        if viewModel.product.sizes.count == 1 {
            presentUnitaryCartConfirmation(product: viewModel.product)
        }
        else {
            presentSelectableCartConfirmation(product: viewModel.product)
        }
    }
    
    @objc func didTapCartButton() {
        delegate?.storeProductDetailsViewController(self, goToCart: ())
    }
    
    // MARK: - PRIVATE METHODS

    private func setCartCount(_ count: Int) {
        cartButton.badgeValue = count
    }
    
    private func displayProduct(_ product: StoreProduct) {
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
    
    private func presentUnitaryCartConfirmation(product: StoreProduct) {
        guard let size = product.sizes[safe: 0] else { return }
        handleAddToCart(size: size, product: product)
        let sizeAlert = UIAlertController(title: Localization.Generic.AddToCart.Unitary.title,
                                          message: Localization.Generic.AddToCart.Unitary.message(product.name.lowercased(), size.size),
                                          preferredStyle: .alert)
        sizeAlert.addAction(UIAlertAction(title: Localization.Generic.AddToCart.Unitary.confirm,
                                          style: .cancel))
        present(sizeAlert, animated: true)
    }
    
    private func presentSelectableCartConfirmation(product: StoreProduct) {
        let sizeAlert = UIAlertController(title: Localization.Generic.AddToCart.Multiple.title,
                                          message: Localization.Generic.AddToCart.Multiple.message(product.name.lowercased()),
                                          preferredStyle: .alert)
        for size in product.sizes where size.available {
            sizeAlert.addAction(UIAlertAction(title: size.size,
                                              style: .default,
                                              handler: { [weak self] _ in
                self?.handleAddToCart(size: size, product: product)
            }))
        }
        sizeAlert.addAction(UIAlertAction(title: Localization.Generic.AddToCart.Multiple.cancel,
                                          style: .cancel))
        present(sizeAlert, animated: true, completion: nil)
    }
    
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
