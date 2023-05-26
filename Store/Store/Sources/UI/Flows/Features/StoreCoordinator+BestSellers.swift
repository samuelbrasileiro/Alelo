//
//  StoreCoordinator+BestSellers.swift
//  Store
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import UIKit

extension StoreCoordinator {
    func makeStoreBestSellersViewController() -> UIViewController {
        let viewController = resolver.resolve(StoreBestSellersViewController.self)
        viewController.delegate = self
        return viewController
    }
}

extension StoreCoordinator: StoreBestSellersViewControllerDelegate {
    func storeBestSellersViewController(_ viewController: StoreBestSellersViewController, goToProduct product: StoreProduct) {
        navigate(to: .productDetails)
    }
}
