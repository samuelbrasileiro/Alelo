//
//  StoreBestSellersViewModelTests.swift
//  Store
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import XCTest
import Combine
@testable import Store
import ModuleIntegrator

class StoreBestSellersViewModelTests: XCTestCase {
    
    var viewModel: StoreBestSellersViewModel!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let resolver = StoreTestsIntegrator.build()
        viewModel = resolver.resolve(StoreBestSellersViewModel.self)
    }
    
    override func tearDownWithError() throws {
        subscriptions.removeAll()
        viewModel = nil
    }
    
    func testSetup_ShouldRetrieveBestSellersAndCartCountSuccessViewStates() {
        // Assign
        let retrieveBestSellersExpectation = expectation(description: "Retrieve Best Sellers")
        retrieveBestSellersExpectation.expectedFulfillmentCount = 2
        let retrieveCartCountExpectation = expectation(description: "Retrieve Cart Count")
        
        // Act
        viewModel.changeViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveBestSellersExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.cartCountViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveCartCountExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.setup()
        
        wait(for: [retrieveBestSellersExpectation, retrieveCartCountExpectation], timeout: 5.0)
    }
    
    func testRetrieveCartCount_ShouldRetrieveCartCountSuccessViewState() {
        // Assign
        let retrieveCartCountExpectation = expectation(description: "Retrieve Cart Count")
        
        // Act
        viewModel.cartCountViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveCartCountExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.retrieveCartCount()
        
        wait(for: [retrieveCartCountExpectation], timeout: 5.0)
    }
    
    func testSetFilter_WhenApplyingInPromotionFilter_ShouldProductsBeAllInPromotion() {
        //Assign
        var productOnSale = StoreProduct.dirty
        productOnSale.onSale = true
        var productOffSale = StoreProduct.dirty
        productOffSale.onSale = false
        
        viewModel.products = [productOnSale, productOffSale, productOffSale, productOnSale, productOnSale]
        
        viewModel.filter = nil
        
        //Act
        viewModel.setFilter(kind: .inPromotion)
        
        let productsOnSale = viewModel.products.filter({$0.onSale})
        let productsOffSale = viewModel.products.filter({!$0.onSale})
        
        //Assert
        XCTAssertEqual(viewModel.filter, .inPromotion)
        XCTAssertEqual(productsOnSale.count, 3)
        XCTAssertEqual(productsOffSale.count, 0)
    }
    
    func testRemoveFilter_WhenRemovingFilter_ShouldRemoveFilterAndShowAllProducts() {
        //Assign
        var productOnSale = StoreProduct.dirty
        productOnSale.onSale = true
        var productOffSale = StoreProduct.dirty
        productOffSale.onSale = false
        
        viewModel.products = [productOnSale, productOffSale, productOffSale, productOnSale, productOnSale]
        viewModel.setFilter(kind: .inPromotion)
        
        //Act
        viewModel.removeFilter()

        let productsOnSale = viewModel.products.filter({$0.onSale})
        let productsOffSale = viewModel.products.filter({!$0.onSale})
        
        //Assert
        XCTAssertEqual(viewModel.filter, nil)
        XCTAssertEqual(productsOnSale.count, 3)
        XCTAssertEqual(productsOffSale.count, 2)
    }
    
    func testAddProduct_WhenAddingAProduct_ShouldFlagDidUpdateCart() {
        // Assign
        let product = StoreProduct.dirty
        let size = StoreSize.dirty
        
        let didUpdateCartExpectation = expectation(description: "Did Update Cart")
        
        // Act
        StoreCartObserver.shared.didUpdateCart.sink { viewState in
            didUpdateCartExpectation.fulfill()
        }.store(in: &subscriptions)

        viewModel.addToCart(size: size, product: product)
        
        wait(for: [didUpdateCartExpectation], timeout: 5.0)
    }
}
