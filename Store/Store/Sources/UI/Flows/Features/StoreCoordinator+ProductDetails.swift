//
//  StoreCoordinator+ProductDetails.swift
//  Store
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import UIKit

extension StoreCoordinator {
    func makeStoreProductDetailsViewController(product: StoreProduct) -> UIViewController {
        let viewController = resolver.resolve(StoreProductDetailsViewController.self, argument: product)
        viewController.delegate = self
        return viewController
    }
}

extension StoreCoordinator: StoreProductDetailsViewControllerDelegate {
    func storeProductDetailsViewController(_ viewController: StoreProductDetailsViewController, goToCart _: Void) {
        navigate(to: .cart)
    }
}
