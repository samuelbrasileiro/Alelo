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
    
    lazy private var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.isHidden = true
        return spinner
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
        navigationItem.title = "Best Sellers"
        collectionView.refreshControl = refresh
        navigationItem.setRightBarButton(cartButton, animated: true)
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
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func handleSuccess() {
        isLoading = false
        collectionView.reloadData()
        spinner.isHidden = true
        spinner.stopAnimating()
        view.layoutIfNeeded()
    }
    
    private func handleError(_ error: Error) {
        isLoading = false
        showError(error)
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func didTapProduct(_ product: StoreProduct) {
        print("Did tap cell of \(product.name)")
        delegate?.storeBestSellersViewController(self, goToProduct: product)
    }
    
    @objc private func didTapCartButton() {
        delegate?.storeBestSellersViewController(self, goToCart: ())
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
