//
//  StoreValueConfirmationViewTests.swift
//  StoreTests
//
//  Created by Samuel Brasileiro on 29/05/23.
//

import XCTest
import Combine
@testable import Store

class StoreValueConfirmationViewTests: XCTestCase {
    
    var view: StoreValueConfirmationView!
    var subscriptions = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        
        view = StoreValueConfirmationView()
    }
    
    override func tearDown() {
        view = nil
        subscriptions.removeAll()
        
        super.tearDown()
    }
    
    // MARK: - TESTS
    
    func testSetup_WhenSettingUpDescriptionAndButtonTexts_TextsAreEqual() {
        // Arrange
        let descriptionText = "Description"
        let buttonText = "Button"
        
        // Act
        view.setup(descriptionText: descriptionText, buttonText: buttonText)
        
        // Assert
        XCTAssertEqual(view.descriptionLabel.text, descriptionText)
        XCTAssertEqual(view.completeButton.title(for: .normal), buttonText)
    }
    
    func testUpdatePrice_WhenUpdatingPrice_TextIsEqual() {
        // Arrange
        let priceText = "R$ 100,00"
        
        // Act
        view.update(priceText: priceText)
        
        // Assert
        XCTAssertEqual(view.priceLabel.text, priceText)
    }
    
    func testCompleteButton_WhenTappingInCompleteButton_CallsObserver() {
        // Assign
        let didTapCompleteButtonExpectation = expectation(description: "Did Tap Complete Button")

        // Arrange
        view.tapCompleteButton.compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { product in
                // Assert
                didTapCompleteButtonExpectation.fulfill()
            }
            .store(in: &subscriptions)
        
        // Act
        view.didTapCompleteButton(sender: view.completeButton)
        
        // Assert
        wait(for: [didTapCompleteButtonExpectation], timeout: 1.0)
    }
    
    func testDisabledState_WhenDisabledIsActive() {
        // Arrange
        view.disabled = true
        
        // Assert
        XCTAssertEqual(view.completeButton.backgroundColor?.cgColor, UIColor.systemGray4.cgColor)
        XCTAssertEqual(view.completeButton.titleLabel?.textColor.cgColor, UIColor.systemGray.cgColor)
        XCTAssertFalse(view.completeButton.isEnabled)
    }
    
    func testDisabledState_WhenDisabledIsInactive() {
        // Arrange
        view.disabled = false
        
        // Assert
        XCTAssertEqual(view.completeButton.backgroundColor?.cgColor, UIColor.label.cgColor)
        XCTAssertEqual(view.completeButton.titleLabel?.textColor.cgColor, UIColor.systemBackground.cgColor)
        XCTAssertTrue(view.completeButton.isEnabled)
    }
}
