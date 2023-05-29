import XCTest
import Combine
@testable import Service

class NetworkServiceTests: XCTestCase {
    private var subscriptions: Set<AnyCancellable> = []
    
    func testFetch_SuccessfulResponse_DecodesData() {
        // Arrange
        let session = MockServiceSession()
        let networkService = NetworkService(session: session)
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let expectedResult = [
            Product(id: 0, name: "Product 0"),
            Product(id: 1, name: "Product 1"),
            Product(id: 2, name: "Product 2")
        ]
        let request = MockServiceRequest(path: "v3/38594ad1-12de-49b3-a74f-c8c852db8337", method: .get)
        
        // Act
        networkService.fetch([Product].self, from: request) { result in
            switch result {
            case .success:
                // Assert
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch failed with error: \(error)")
            }
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetch_InvalidPath_ReturnsInvalidStatusCode() {
        // Arrange
        let session = MockServiceSession()
        let networkService = NetworkService(session: session)
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let requestWithInvalidPath = MockServiceRequest(path: "invalid-path", method: .get)
        
        // Act
        networkService.fetch([Product].self, from: requestWithInvalidPath) { result in
            switch result {
            case .success:
                XCTFail("Fetch should have failed with an error")
            case .failure(let error):
                // Assert
                if case .invalidStatusCode = error {
                    XCTAssert(true)
                    expectation.fulfill()
                } else {
                    XCTFail("Fetch failed with unexpected error: \(error)")
                }
            }
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetch_DataNotDecoded_ReturnsDataNotDecodedError() {
        // Arrange
        let session = MockServiceSession()
        let networkService = NetworkService(session: session)
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let requestWithInvalidData = MockServiceRequest(path: "v3/2eba4f54-58bc-40bc-b72c-b6351caeb4cf", method: .get)
        
        // Act
        networkService.fetch([Product].self, from: requestWithInvalidData) { result in
            switch result {
            case .success:
                XCTFail("Fetch should have failed with an error")
            case .failure(let error):
                // Assert
                if case .dataNotDecoded = error {
                    expectation.fulfill()
                } else {
                    XCTFail("Fetch failed with unexpected error: \(error)")
                }
            }
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetch_CustomError_ReturnsCustomError() {
        // Arrange
        let session = MockServiceSession()
        let networkService = NetworkService(session: session)
        let expectation = XCTestExpectation(description: "Fetch completion")
        
        let customError = ErrorCodable(error: "Error", message: "Message")
        
        let requestWithCustomError = MockServiceRequest(path: "v3/e3366530-ec82-4980-bf8c-0b86d5924a11", method: .get)
        
        // Act
        networkService.fetch([Product].self, from: requestWithCustomError) { result in
            switch result {
            case .success:
                XCTFail("Fetch should have failed with an error")
            case .failure(let error):
                // Assert
                if case .custom(let error, let message) = error {
                    XCTAssertEqual(error, customError.error)
                    XCTAssertEqual(message, customError.message)
                    expectation.fulfill()
                } else {
                    XCTFail("Fetch failed with unexpected error: \(error)")
                }
            }
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - HELPERS
    
    class MockServiceSession: ServiceSessionProtocol {
        var baseURL: String {
            return "https://run.mocky.io/"
        }

        func buildFinalPath(from request: ServiceRequest) -> String {
            return baseURL + request.path
        }
    }
}

struct Product: Codable, Equatable {
    let id: Int
    let name: String
}

struct MockServiceRequest: ServiceRequest {
    let path: String
    let method: ServiceHTTPMethod
}
