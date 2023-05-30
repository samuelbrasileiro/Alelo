import XCTest
@testable import DependencyInjection

// Dependency Container Tests are limited due to preconditions
class DependencyContainerTests: XCTestCase {
    
    var container: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        
        container = DependencyContainer()
    }
    
    override func tearDown() {
        container = nil
        
        super.tearDown()
    }
    
    // MARK: - TESTS
    
    func testContainer_WhenRegisteringDependencyWithoutArgument_ResolvingSameDependencyWithoutArgumentIsSuccess() {
        // Arrange
        class TestObject {
            let id = "a"
        }
        
        // Act
        container.register(TestObject.self) { resolver in
            return TestObject()
        }
        let object = container.resolve(TestObject.self)
        
        // Assert
        XCTAssertNotNil(object)
        XCTAssertEqual(object.id, "a")
    }
    
    func testContainer_WhenRegisteringDependencyWithArgument_ResolvingSameDependencyWithArgumentIsSuccess() {
        // Arrange
        struct TestModel {
            var id: String
        }

        class TestObjectWithArgument {
            let id: TestModel
            
            init(id: TestModel) {
                self.id = id
            }
        }
        let model = TestModel(id: "b")
        
        // Act
        container.register(TestObjectWithArgument.self) { (resolver, model: TestModel) in
            return TestObjectWithArgument(id: model)
        }
        let object = self.container.resolve(TestObjectWithArgument.self, argument: model)
        
        // Assert
        XCTAssertNotNil(object)
        XCTAssertEqual(object.id.id, "b")
    }
    
    func testContainer_WhenRegisteringDependencyProtocolWithoutParameter_ResolvingSameDependencyProtocolIsSuccess() {
        // Arrange
        class TestObjectInherited: TestObjectProtocol {
            let id = "c"
            
            func getId() -> String {
                return id
            }
        }
        
        // Act
        container.register(TestObjectProtocol.self) { resolver in
            return TestObjectInherited()
        }
        let object = container.resolve(TestObjectProtocol.self)
        
        // Assert
        XCTAssertNotNil(object)
        XCTAssertEqual(object.getId(), "c")
    }
    
    func testContainer_WhenRegisteringDependencyProtocolWithParameter_ResolvingSameDependencyProtocolIsSuccess() {
        // Arrange
        class TestObjectInheritedWithParameter: TestObjectProtocol {
            private var id: String
            
            init(id: String) {
                self.id = id
            }
            
            func getId() -> String {
                return id
            }
        }
        let id = "d"
        
        // Act
        container.register(TestObjectProtocol.self) { (resolver, id: String) in
            return TestObjectInheritedWithParameter(id: id)
        }
        let object = container.resolve(TestObjectProtocol.self, argument: id)
        
        // Assert
        XCTAssertNotNil(object)
        XCTAssertEqual(object.getId(), "d")
    }
}

protocol TestObjectProtocol {
    func getId() -> String
}
