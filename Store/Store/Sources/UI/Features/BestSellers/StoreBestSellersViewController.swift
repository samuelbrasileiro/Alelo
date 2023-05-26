//
//  StoreBestSellersViewController.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import Combine
import Commons
import UIKit

protocol StoreBestSellersViewControllerDelegate: AnyObject {
    func storeBestSellersViewController(_ viewController: StoreBestSellersViewController, goToProduct product: StoreProduct)
}

class StoreBestSellersViewController: UIViewController {
    
    // MARK: - PUBLIC ATTRIBUTES
    
    weak var delegate: StoreBestSellersViewControllerDelegate?
    
    // MARK: - PRIVATE ATTRIBUTES
    
    private let viewModel: StoreBestSellersViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - UI
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StoreProductCell.self, forCellReuseIdentifier: StoreProductCell.cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        navigationItem.title = "Best Sellers"
        tableView.tableFooterView = spinner
        tableView.refreshControl = refresh
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
        spinner.isHidden = false
        spinner.startAnimating()
    }
    
    private func handleSuccess() {
        tableView.reloadData()
        spinner.isHidden = true
        spinner.stopAnimating()
        view.layoutIfNeeded()
    }
    
    private func handleError(_ error: Error) {
        showError(error)
        spinner.isHidden = true
        spinner.stopAnimating()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func didTapProduct(_ product: StoreProduct) {
        print("Did tap cell of \(product.name)")
        delegate?.storeBestSellersViewController(self, goToProduct: product)
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

// MARK: - UITableViewDelegate

extension StoreBestSellersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreProductCell.cellReuseIdentifier,
                                                       for: indexPath) as? StoreProductCell,
              let product = viewModel.products[safe: indexPath.row] else { return StoreProductCell() }
        cell.setup(product: product)
        cell.tapView.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] product in
                self?.didTapProduct(product)
            }
            .store(in: &cell.subscribers)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}
