//
//  StoreProductCellTests.swift
//  StoreTests
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import Combine
import XCTest
@testable import Store

class StoreProductCellTests: XCTestCase {
    
    var cell: StoreProductCell!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        
        cell = StoreProductCell(frame: .zero)
    }
    
    override func tearDown() {
        subscriptions.removeAll()
        cell = nil
        
        super.tearDown()
    }
    
    // MARK: - TESTS
    
    func testCellSetup_WhenSettingUpOnSaleProduct() {
        // Arrange
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreProduct(name: "Camisa",
                                   onSale: true,
                                   regularPrice: "R$ 100,00",
                                   actualPrice: "R$ 90,00",
                                   discountPercentage: "10%",
                                   installments: "3x de R$ 30,00",
                                   image: "",
                                   sizes: [size, size])
        
        // Act
        cell.setup(product: product)
        
        // Assert
        XCTAssertEqual(cell.nameLabel.text, "Camisa")
        XCTAssertEqual(cell.priceLabel.text, "R$ 90,00")
        XCTAssertEqual(cell.discountLabel.text, "R$ 100,00")
        XCTAssertEqual(cell.discountPercentageLabel.text, "10%")
        XCTAssertEqual(cell.promoLabel.text, "PROMO")
        XCTAssertEqual(cell.installmentsLabel.text, "3x de R$ 30,00")
        XCTAssertFalse(cell.discountLabel.isHidden)
        XCTAssertFalse(cell.discountPercentageLabel.isHidden)
        XCTAssertFalse(cell.promoLabel.isHidden)
        XCTAssertEqual(cell.sizesStack.arrangedSubviews.count, 2)
    }
    
    func testCellSetup_WhenSettingUpOffSaleProduct() {
        // Arrange
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreProduct(name: "Camisa",
                                   onSale: false,
                                   regularPrice: "R$ 90,00",
                                   actualPrice: "R$ 90,00",
                                   discountPercentage: "",
                                   installments: "3x de R$ 30,00",
                                   image: "",
                                   sizes: [size, size])
        
        // Act
        cell.setup(product: product)
        
        // Assert
        XCTAssertEqual(cell.nameLabel.text, "Camisa")
        XCTAssertEqual(cell.priceLabel.text, "R$ 90,00")
        XCTAssertEqual(cell.installmentsLabel.text, "3x de R$ 30,00")
        XCTAssertTrue(cell.discountLabel.isHidden)
        XCTAssertTrue(cell.discountPercentageLabel.isHidden)
        XCTAssertTrue(cell.promoLabel.isHidden)
        XCTAssertEqual(cell.sizesStack.arrangedSubviews.count, 2)
    }
    
    func testCellDidTapView_WhenTappingView_SendsProduct() {
        // Arrange
        let didTapViewExpectation = expectation(description: "Did Tap View")
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreProduct(name: "Camisa",
                                   onSale: false,
                                   regularPrice: "R$ 90,00",
                                   actualPrice: "R$ 90,00",
                                   discountPercentage: "",
                                   installments: "3x de R$ 30,00",
                                   image: "",
                                   sizes: [size, size])
        cell.setup(product: product)
        
        // Act
        cell.tapView.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { model in
                // Assert
                XCTAssertEqual(model.name, "Camisa")
                didTapViewExpectation.fulfill()
            }
            .store(in: &subscriptions)
        cell.didTapView()

        wait(for: [didTapViewExpectation], timeout: 1.0)
    }
    
    
    func testCellDidTapAddToCartButton_WhenTappingButton_AddsToCart() {
        // Arrange
        let didTapAddToCartExpectation = expectation(description: "Did Tap Add To Cart")
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreProduct(name: "Camisa",
                                   onSale: false,
                                   regularPrice: "R$ 90,00",
                                   actualPrice: "R$ 90,00",
                                   discountPercentage: "",
                                   installments: "3x de R$ 30,00",
                                   image: "",
                                   sizes: [size, size])
        cell.setup(product: product)
        
        // Act
        cell.tapAddToCartButton.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { model in
                // Assert
                XCTAssertEqual(model.name, "Camisa")
                didTapAddToCartExpectation.fulfill()
            }
            .store(in: &subscriptions)
        cell.didTapAddToCartButton(sender: cell.addToCartButton)

        wait(for: [didTapAddToCartExpectation], timeout: 1.0)
    }
}
