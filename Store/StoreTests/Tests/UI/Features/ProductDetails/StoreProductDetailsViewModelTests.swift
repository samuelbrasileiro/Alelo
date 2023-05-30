//
//  StoreProductDetailsViewModelTests.swift
//  StoreTests
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import XCTest
import Combine
@testable import Store
import ModuleIntegrator

class StoreProductDetailsViewModelTests: XCTestCase {
    
    var viewModel: StoreProductDetailsViewModel!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let resolver = StoreTestsIntegrator.build()
        let product = StoreProduct.dirty
        viewModel = resolver.resolve(StoreProductDetailsViewModel.self, argument: product)
    }
    
    override func tearDownWithError() throws {
        subscriptions.removeAll()
        viewModel = nil
    }
    
    func testSetup_ShouldRetrieveCartCountSuccessViewStates() {
        // Assign
        let retrieveProductExpectation = expectation(description: "Retrieve Product")
        let retrieveCartCountExpectation = expectation(description: "Retrieve Cart Count")
        
        // Act
        viewModel.changeViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveProductExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.cartCountViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveCartCountExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.setup()
        
        wait(for: [retrieveProductExpectation, retrieveCartCountExpectation], timeout: 5.0)
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
