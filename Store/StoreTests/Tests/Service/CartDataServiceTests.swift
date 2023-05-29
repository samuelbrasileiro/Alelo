//
//  CartDataServiceTests.swift
//  StoreTests
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import XCTest
@testable import Store

class CartDataServiceTests: XCTestCase {
    
    var cartDataService: CartDataService!
    
    override func setUp() {
        super.setUp()
        cartDataService = CartDataService.shared
        cartDataService.clear()

    }
    
    override func tearDown() {
        cartDataService = nil
        super.tearDown()
    }
    
    // MARK: - TESTS
    
    func testCartDataService_WhenAddingProduct_IncrementsQuantityIfExists() {
        // Arrange
        let product = createProduct(sku: "123", quantity: 1)
        
        // Act
        cartDataService.add(product: product)
        cartDataService.add(product: product)

        // Assert
        XCTAssertEqual(cartDataService.getAll().count, 1)
        XCTAssertEqual(cartDataService.getAll().first?.quantity, 2)
    }
    
    func testCartDataService_WhenAddingProduct_AddsNewProductIfNotExists() {
        // Arrange
        let product1 = createProduct(sku: "123", quantity: 1)
        let product2 = createProduct(sku: "456", quantity: 1)
        
        // Act
        cartDataService.add(product: product1)
        cartDataService.add(product: product2)
        
        // Assert
        XCTAssertEqual(cartDataService.getAll().count, 2)
    }
    
    func testCartDataService_WhenUpdatingProduct_UpdatesQuantityIfGreaterThanZero() {
        // Arrange
        let product = createProduct(sku: "123", quantity: 1)
        cartDataService.add(product: product)
        
        // Act
        let updatedProduct = createProduct(sku: "123", quantity: 3)
        cartDataService.update(product: updatedProduct)
        
        // Assert
        XCTAssertEqual(cartDataService.getAll().first?.quantity, 3)
    }
    
    func testCartDataService_WhenUpdatingProduct_RemovesProductIfQuantityIsZero() {
        // Arrange
        let product = createProduct(sku: "123", quantity: 1)
        cartDataService.add(product: product)
        
        // Act
        let updatedProduct = createProduct(sku: "123", quantity: 0)
        cartDataService.update(product: updatedProduct)
        
        // Assert
        XCTAssertEqual(cartDataService.getAll().count, 0)
    }
    
    func testCartDataService_WhenGettingAll_ReturnsAllProducts() {
        // Arrange
        let product1 = createProduct(sku: "123", quantity: 1)
        let product2 = createProduct(sku: "456", quantity: 1)
        cartDataService.add(product: product1)
        cartDataService.add(product: product2)
        
        // Act
        let allProducts = cartDataService.getAll()
        
        // Assert
        XCTAssertEqual(allProducts.count, 2)
        XCTAssertTrue(allProducts.contains(product1))
        XCTAssertTrue(allProducts.contains(product2))
    }
    
    func testCartDataService_WhenGettingCount_ReturnsTotalProductCount() {
        // Arrange
        let product1 = createProduct(sku: "123", quantity: 2)
        let product2 = createProduct(sku: "456", quantity: 3)
        cartDataService.add(product: product1)
        cartDataService.add(product: product2)
        
        // Act
        let count = cartDataService.getCount()
        
        // Assert
        XCTAssertEqual(count, 5)
    }
    
    
    // MARK: - HELPER
    
    private func createProduct(sku: String, quantity: Int) -> StoreCartProduct {
        var model = StoreCartProduct.dirty
        model.chosenSize.sku = sku
        model.quantity = quantity
        return model
    }
}
