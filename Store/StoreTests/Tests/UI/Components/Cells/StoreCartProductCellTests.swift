//
//  StoreCartProductCellTests.swift
//  StoreTests
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import Combine
import XCTest
@testable import Store

class StoreCartProductCellTests: XCTestCase {
    
    var cell: StoreCartProductCell!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        
        cell = StoreCartProductCell(style: .default, reuseIdentifier: "TestCell")
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
        let product = StoreCartProduct(chosenSize: size,
                                       quantity: 2,
                                       item: .init(name: "Camisa",
                                                   onSale: true,
                                                   regularPrice: "R$ 100,00",
                                                   actualPrice: "R$ 90,00",
                                                   discountPercentage: "10%",
                                                   installments: "3x de R$ 30,00",
                                                   image: "",
                                                   sizes: [size]))
        
        // Act
        cell.setup(product: product)
        
        // Assert
        XCTAssertEqual(cell.nameLabel.text, "Camisa")
        XCTAssertEqual(cell.priceLabel.text, "R$ 90,00")
        XCTAssertEqual(cell.discountLabel.text, "R$ 100,00")
        XCTAssertFalse(cell.discountLabel.isHidden)
        XCTAssertEqual(cell.sizeLabel.text, "M")
        XCTAssertEqual(cell.countStepper.value, 2)
        XCTAssertEqual(cell.countLabel.text, "2 ITENS")
    }
    
    func testCellSetup_WhenSettingUpOffSaleProduct() {
        // Arrange
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreCartProduct(chosenSize: size,
                                       quantity: 2,
                                       item: .init(name: "Camisa",
                                                   onSale: false,
                                                   regularPrice: "R$ 90,00",
                                                   actualPrice: "R$ 90,00",
                                                   discountPercentage: "10%",
                                                   installments: "3x de R$ 30,00",
                                                   image: "",
                                                   sizes: [size]))
        
        // Act
        cell.setup(product: product)
        
        // Assert
        XCTAssertEqual(cell.nameLabel.text, "Camisa")
        XCTAssertEqual(cell.priceLabel.text, "R$ 90,00")
        XCTAssertTrue(cell.discountLabel.isHidden)
        XCTAssertEqual(cell.sizeLabel.text, "M")
        XCTAssertEqual(cell.countStepper.value, 2)
        XCTAssertEqual(cell.countLabel.text, "2 ITENS")
    }
    
    func testCellSetup_WhenSettingUp1Quantity_DisplayItem() {
        // Arrange
        var product = StoreCartProduct.dirty
        product.quantity = 1
        
        // Act
        cell.setup(product: product)
        
        // Assert
        XCTAssertEqual(cell.countLabel.text, "1 ITEM")
    }
    
    func testCellSetup_WhenSettingUpMoreThan1Quantity_DisplayItens() {
        // Arrange
        var product = StoreCartProduct.dirty
        product.quantity = 5
        
        // Act
        cell.setup(product: product)
        
        // Assert
        XCTAssertEqual(cell.countLabel.text, "5 ITENS")
    }
    
    func testCellStepperValueChanged_WhenValueIsChanged_ProductIsUpdated() {
        // Arrange
        let didUpdateCartExpectation = expectation(description: "Did Update Cart")
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreCartProduct(chosenSize: size,
                                       quantity: 1,
                                       item: .init(name: "Camisa",
                                                   onSale: false,
                                                   regularPrice: "R$ 90,00",
                                                   actualPrice: "R$ 90,00",
                                                   discountPercentage: "10%",
                                                   installments: "3x de R$ 30,00",
                                                   image: "",
                                                   sizes: [size]))
        cell.setup(product: product)

        // Act
        cell.countStepper.value = 3
        cell.tapUpdateCartButton.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { product in
                // Assert
                XCTAssertEqual(product.quantity, 3)
                didUpdateCartExpectation.fulfill()
            }
            .store(in: &subscriptions)
        cell.stepperDidChange(sender: cell.countStepper)

        // Assert
        XCTAssertEqual(cell.countLabel.text, "3 ITENS")
        XCTAssertEqual(cell.countStepper.value, 3)
        
        wait(for: [didUpdateCartExpectation], timeout: 1.0)
    }
    
    func testCellDidTapView_WhenTappingView_SendsProduct() {
        // Arrange
        let didTapViewExpectation = expectation(description: "Did Tap View")
        let size = StoreSize(available: true,
                             size: "M",
                             sku: "1")
        let product = StoreCartProduct(chosenSize: size,
                                       quantity: 1,
                                       item: .init(name: "Camisa",
                                                   onSale: false,
                                                   regularPrice: "R$ 90,00",
                                                   actualPrice: "R$ 90,00",
                                                   discountPercentage: "10%",
                                                   installments: "3x de R$ 30,00",
                                                   image: "",
                                                   sizes: [size]))
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
}
