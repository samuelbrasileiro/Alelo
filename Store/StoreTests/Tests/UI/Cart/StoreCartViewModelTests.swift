//
//  StoreCartViewModelTests.swift
//  StoreTests
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import XCTest
import Combine
@testable import Store
import ModuleIntegrator

class StoreCartViewModelTests: XCTestCase {
    
    var viewModel: StoreCartViewModel!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let resolver = StoreTestsIntegrator.build()
        viewModel = resolver.resolve(StoreCartViewModel.self)
    }
    
    override func tearDownWithError() throws {
        subscriptions.removeAll()
        viewModel = nil
    }
    
    func testSetup_ShouldRetrieveCartSuccessViewState() {
        // Assign
        let retrieveCartExpectation = expectation(description: "Retrieve Cart Expectation")
        
        // Act
        viewModel.changeViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveCartExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.setup()
        
        wait(for: [retrieveCartExpectation], timeout: 5.0)
    }
    
    func testRetrieveCart_ShouldRetrieveCartSuccessViewState() {
        // Assign
        let retrieveCartExpectation = expectation(description: "Retrieve Cart Expectation")
        
        // Act
        viewModel.changeViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveCartExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.setup()
        
        wait(for: [retrieveCartExpectation], timeout: 5.0)
    }
    
    func testUpdateCart_ShouldRetrieveCartSuccessViewState() {
        // Assign
        let retrieveCartExpectation = expectation(description: "Retrieve Cart Expectation")
        
        // Act
        viewModel.changeViewState.sink { viewState in
            if case .success = viewState {
                // Assert
                retrieveCartExpectation.fulfill()
            }
        }.store(in: &subscriptions)
        
        viewModel.setup()
        
        wait(for: [retrieveCartExpectation], timeout: 5.0)
    }
    
    func testGetTotalPriceText_ShouldSumAllPricesAndFormat() {
        // Assign
        var product1 = StoreCartProduct.dirty
        product1.item.actualPrice = "R$ 205,30"
        product1.quantity = 1
        var product2 = StoreCartProduct.dirty
        product2.item.actualPrice = "R$ 12,99"
        product2.quantity = 1
        var product3 = StoreCartProduct.dirty
        product3.item.actualPrice = "R$ 9,00"
        product3.quantity = 3
        viewModel.products = [product1, product2, product3]
        
        // Act
        let value = viewModel.getTotalPriceText()
        
        // Assert
        XCTAssertEqual(value, "R$ 245.29")
    }
    
    func testIsCartEmpty_WhenCartIsEmpty_ShouldReturnTrue() {
        // Assign
        viewModel.products = []
        
        // Act
        let isEmpty = viewModel.isCartEmpty()
        
        // Assert
        XCTAssertTrue(isEmpty)
    }
    
    func testIsCartEmpty_WhenCartIsNotEmpty_ShouldReturnFalse() {
        // Assign
        let product = StoreCartProduct.dirty
        viewModel.products = [product, product]
        
        // Act
        let isEmpty = viewModel.isCartEmpty()
        
        // Assert
        XCTAssertFalse(isEmpty)
    }
}
