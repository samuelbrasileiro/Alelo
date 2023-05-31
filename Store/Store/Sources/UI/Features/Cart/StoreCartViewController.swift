//
//  StoreCartViewController.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import Combine
import Commons
import UIKit

protocol StoreCartViewControllerDelegate: AnyObject {
    func storeCartViewController(_ viewController: StoreCartViewController, goToProduct product: StoreProduct)
}

class StoreCartViewController: UIViewController {
    
    // MARK: - PUBLIC PROPERTIES
    weak var delegate: StoreCartViewControllerDelegate?
    
    // MARK: - PRIVATE PROPERTIES
    
    private let viewModel: StoreCartViewModel
    private var subscriptions: Set<AnyCancellable> = []
    private var isLoading = true

    // MARK: - UI
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StoreCartProductCell.self, forCellReuseIdentifier: StoreCartProductCell.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy private var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.translatesAutoresizingMaskIntoConstraints = false
        refresh.isHidden = true
        refresh .addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        return refresh
    }()
    
    lazy private var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = .systemGray5
        return view
    }()
    
    lazy private var confirmationView: StoreValueConfirmationView = {
        let view = StoreValueConfirmationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setup(descriptionText: Localization.Features.Cart.ConfirmationView.descriptionText,
                   buttonText: Localization.Features.Cart.ConfirmationView.buttonText)
        return view
    }()
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.systemGray
        label.text = Localization.Features.Cart.EmptyCartLabel.text
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - INITIALIZERS
    
    init(viewModel: StoreCartViewModel) {
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
        
        StoreCartObserver.shared.didUpdateCart
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                self?.viewModel.retrieveCartProducts()
            }.store(in: &subscriptions)
    }
    
    private func setupViewHierarchy() {
        view.addSubview(tableView)
        view.addSubview(separatorView)
        view.addSubview(confirmationView)
        view.addSubview(emptyCartLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            separatorView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            confirmationView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyCartLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = Localization.Features.Cart.navigationTitle
        tableView.refreshControl = refresh
    }
    
    // MARK: - HANDLERS
    
    private func handleViewState(_ viewState: StoreCartViewState) {
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
        tableView.reloadData()
        isLoading = false
        confirmationView.update(priceText: viewModel.getTotalPriceText())
        confirmationView.disabled = viewModel.isCartEmpty()
        emptyCartLabel.isHidden = !viewModel.isCartEmpty()
    }
    
    private func handleError(_ error: Error) {
        showError(error)
        isLoading = false
    }

    // MARK: - ACTIONS
    
    func didTapProduct(_ product: StoreProduct) {
        delegate?.storeCartViewController(self, goToProduct: product)
    }
    
    func didTapUpdateCart(_ product: StoreCartProduct) {
        if product.quantity == 0 {
            presentRemovalConfirmation(product: product)
        } else {
            viewModel.updateCart(product: product)
        }
    }
    
    // MARK: - PRIVATE METHODS
    
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
    
    private func presentRemovalConfirmation(product: StoreCartProduct) {
        let removalAlert = UIAlertController(title: Localization.Features.Cart.RemovalConfirmation.title,
                                             message: Localization.Features.Cart.RemovalConfirmation.message(product.item.name.lowercased()),
                                             preferredStyle: .alert)
        removalAlert.addAction(UIAlertAction(title: Localization.Features.Cart.RemovalConfirmation.remove,
                                             style: .destructive,
                                             handler: { [weak self] _ in
            self?.viewModel.updateCart(product: product)
        }))
        removalAlert.addAction(UIAlertAction(title: Localization.Features.Cart.RemovalConfirmation.cancel,
                                             style: .cancel))
        present(removalAlert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension StoreCartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreCartProductCell.cellReuseIdentifier,
                                                       for: indexPath) as? StoreCartProductCell,
              let product = viewModel.products[safe: indexPath.row] else { return StoreCartProductCell() }
        cell.setup(product: product)
        cell.tapView.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.didTapProduct(product)
            }
            .store(in: &cell.subscribers)
        cell.tapUpdateCartButton.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.didTapUpdateCart(product)
            }
            .store(in: &cell.subscribers)
        return cell
    }
}
