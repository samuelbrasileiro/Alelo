//
//  StoreBestSellersViewController.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import Commons
import Core
import UIKit
import UIView_Shimmer

protocol StoreBestSellersViewControllerDelegate: AnyObject {
    func storeBestSellersViewController(_ viewController: StoreBestSellersViewController, goToProduct product: StoreProduct)
    func storeBestSellersViewController(_ viewController: StoreBestSellersViewController, goToCart _: Void)
}

class StoreBestSellersViewController: UIViewController {
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: StoreBestSellersViewControllerDelegate?
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: StoreBestSellersViewModel
    private var subscriptions: Set<AnyCancellable> = []
    private var isLoading = true
    
    // MARK: - UI
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StoreProductCell.self, forCellWithReuseIdentifier: StoreProductCell.cellReuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy private var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.isHidden = true
        refresh .addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refresh
    }()
    
    lazy private var cartButton: CoreBarButtonItem = {
        let button = CoreBarButtonItem(image: .init(systemName: "cart"),
                                       target: self,
                                       action: #selector(didTapCartButton))
        return button
    }()
    
    lazy private var filterButton: CoreBarButtonItem = {
        let button = CoreBarButtonItem(image: .init(systemName: "line.3.horizontal.decrease.circle"),
                                       target: self,
                                       action: #selector(didTapFilterButton))
        return button
    }()

    // MARK: - INITIALIZERS
    
    init(viewModel: StoreBestSellersViewModel) {
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
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = Localization.Features.BestSellers.navigationTitle
        collectionView.refreshControl = refresh
        navigationItem.setRightBarButton(cartButton, animated: true)
        navigationItem.setLeftBarButton(filterButton, animated: true)
    }
    
    // MARK: - HANDLERS
    
    private func handleViewState(_ viewState: StoreBestSellersViewState) {
        endRefreshing()
        switch viewState {
        case .loading:
            handleLoading()
        case .success:
            handleSuccess()
        case .error(let error):
            handleError(error)
        }
    }
    
    private func handleLoading() {
        isLoading = true
    }
    
    private func handleSuccess() {
        isLoading = false
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        showError(error)
    }
    
    private func handleFilter(kind: StoreFilterKind) {
        filterButton.badgeValue = 1
        viewModel.setFilter(kind: kind)
    }
    
    private func handleFilterRemoveAll() {
        filterButton.badgeValue = 0
        viewModel.removeFilter()
    }
    
    private func handleAddToCart(size: StoreSize, product: StoreProduct) {
        viewModel.addToCart(size: size, product: product)
    }
    
    private func handleCartCountViewState(_ viewState: StoreCartCountViewState) {
        switch viewState {
        case .success(let count):
            setCartCount(count)
        case .error(let error):
            handleError(error)
        }
    }
    
    // MARK: - ACTIONS
    
    func didTapProduct(_ product: StoreProduct) {
        delegate?.storeBestSellersViewController(self, goToProduct: product)
    }
    
    @objc func didTapCartButton() {
        delegate?.storeBestSellersViewController(self, goToCart: ())
    }
    
    func didTapAddToCart(_ product: StoreProduct) {
        if product.sizes.count == 1 {
            presentUnitaryCartConfirmation(product: product)
        }
        else {
            presentSelectableCartConfirmation(product: product)
        }
    }
    
    @objc func didTapFilterButton() {
        presentFilterSheet()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func setCartCount(_ count: Int) {
        cartButton.badgeValue = count
    }
    
    private func presentFilterSheet() {
        let filterSheet = UIAlertController(title: Localization.Features.BestSellers.Filter.title, message: nil, preferredStyle: .actionSheet)
        
        filterSheet.addAction(UIAlertAction(title: Localization.Features.BestSellers.Filter.Cases.inPromotion,
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.handleFilter(kind: .inPromotion)
        }))
        if viewModel.filter != nil {
            filterSheet.addAction(UIAlertAction(title: Localization.Features.BestSellers.Filter.removeAll,
                                                style: .destructive,
                                                handler: { [weak self] _ in
                self?.handleFilterRemoveAll()
            }))
        }
        
        filterSheet.addAction(UIAlertAction(title: Localization.Features.BestSellers.Filter.cancel,
                                            style: .cancel))
        present(filterSheet, animated: true, completion: nil)
    }
    
    private func endRefreshing() {
        if refresh.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.refresh.endRefreshing()
            }
        }
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        viewModel.setup()
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StoreBestSellersViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.products.count
        if count == 0 { // In Shimmer Status
            return 6
        } else {
            return count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreProductCell.cellReuseIdentifier,
                                                            for: indexPath) as? StoreProductCell else { return StoreProductCell() }
        if let product = viewModel.products[safe: indexPath.row] {
            cell.setup(product: product)
        }
        cell.tapView.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.didTapProduct(product)
            }
            .store(in: &cell.subscribers)
        
        cell.tapAddToCartButton.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.didTapAddToCart(product)
            }
            .store(in: &cell.subscribers)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2
        let height = 320.0
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let product = viewModel.products[safe: indexPath.item] else { return }
        didTapProduct(product)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemGray4)
    }
}
