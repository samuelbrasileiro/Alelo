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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Cart"
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
        case .removeProduct(let indexPath):
            handleRemoveProduct(indexPath: indexPath)
        }
    }
    
    private func handleLoading() {
        isLoading = true
    }
    
    private func handleSuccess() {
        tableView.reloadData()
        isLoading = false
    }
    
    private func handleRemoveProduct(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
    }
    
    private func handleError(_ error: Error) {
        showError(error)
        isLoading = false
    }

    // MARK: - PRIVATE METHODS
    
    private func didTapProduct(_ product: StoreProduct) {
        print("Did tap cell of \(product.name)")
        delegate?.storeCartViewController(self, goToProduct: product)
    }
    
    private func didTapUpdateCart(_ product: StoreCartProduct) {
        if product.quantity == 0 {
            presentRemovalConfirmation(product: product)
        } else {
            viewModel.updateCart(product: product)
        }
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
    
    private func presentRemovalConfirmation(product: StoreCartProduct) {
        let removalAlert = UIAlertController(title: "Deseja mesmo remover?", message: "\(product.item.name.lowercased()) vai sentir falta de você!", preferredStyle: .alert)
        removalAlert.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { [weak self] _ in
            self?.viewModel.updateCart(product: product)
        }))
        removalAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
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