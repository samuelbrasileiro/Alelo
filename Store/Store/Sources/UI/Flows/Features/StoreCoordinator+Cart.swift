//
//  StoreCoordinator+Cart.swift
//  Store
//
//  Created by Samuel Brasileiro on 28/05/23.
//

import UIKit

extension StoreCoordinator {
    func makeStoreCartViewController() -> UIViewController {
        let viewController = resolver.resolve(StoreCartViewController.self)
        viewController.delegate = self
        return viewController
    }
}

extension StoreCoordinator: StoreCartViewControllerDelegate {
    func storeCartViewController(_ viewController: StoreCartViewController, goToProduct product: StoreProduct) {
        navigate(to: .productDetails(product: product))
    }
}
