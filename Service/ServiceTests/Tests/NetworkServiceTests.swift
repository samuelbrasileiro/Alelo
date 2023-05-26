//
//  NetworkServiceTests.swift
//  ServiceTests
//
//  Created by Samuel Brasileiro on 26/05/23.
//

import XCTest
@testable import Service
import ModuleIntegrator

final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkServiceProtocol!
    
    override func setUpWithError() throws {
        let resolver = ServiceTestsIntegrator.build()
        networkService = resolver.resolve(NetworkServiceProtocol.self)
    }

    override func tearDownWithError() throws {

    }
    
    func testNetworkService_WhenFetchingRequestIsSuccessful_ReturnsSuccess() {
        // Arrange
        let request = TestRequest(.response_sucessful)
        let expectation = expectation(description: "Web Response Expectation")
        // Act
        networkService.fetch(ResponseProductsTestModel.self, from: request) { result in
            var isSuccess = false
            if case .success = result {
                isSuccess = true
            }
            // Assert
            XCTAssertTrue(isSuccess)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testNetworkService_WhenFetchingRequestPathIsInvalid_ReturnsInvalidStatusCode() {
        // Arrange
        let request = TestRequest(.wrong_path)
        let expectation = expectation(description: "Web Response Expectation")
        // Act
        networkService.fetch(ResponseProductsTestModel.self, from: request) { result in
            var isInvalidStatusCode = false
            if case .failure(.invalidStatusCode) = result {
                isInvalidStatusCode = true
            }
            // Assert
            XCTAssertTrue(isInvalidStatusCode)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }

    func testNetworkService_WhenFetchingRequestResponseIsNotDecodable_ReturnsServiceError() {
        // Arrange
        let request = TestRequest(.response_sucessful)
        let expectation = expectation(description: "Web Response Expectation")
        // Act
        networkService.fetch([ResponseTestModel].self, from: request) { result in
            var isServiceError = false
            if case .failure(.custom) = result {
                isServiceError = true
            }
            // Assert
            XCTAssertTrue(isServiceError)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
