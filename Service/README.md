# Service Module

The Service module provides a set of components and protocols for performing network requests and handling errors in a modular and reusable way.

### Author

The Service module is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

---

## ServiceError

The `ServiceError` enum represents various error cases that can occur during network requests. It includes the following cases:

- `custom(error: String?, message: String?)`: Represents a custom error with an optional error message and additional information.
- `dataNotFound`: Indicates that the requested data was not found.
- `dataNotDecoded`: Indicates that the retrieved data could not be decoded.
- `invalidURL(url: String)`: Indicates that the provided URL is invalid.
- `invalidStatusCode`: Indicates that the server returned an invalid status code.
- `other(Error)`: Represents any other error that does not fall into the above categories.

The `ServiceError` enum also conforms to the `LocalizedError` protocol, providing localized descriptions and failure reasons for each error case.

## ServiceHTTPMethod

The `ServiceHTTPMethod` enum represents the HTTP methods commonly used in network requests. It includes the following cases:

- `get`: Represents the GET HTTP method.
- `post`: Represents the POST HTTP method.
- `update`: Represents the UPDATE HTTP method.
- `delete`: Represents the DELETE HTTP method.

## ServiceRequest

The `ServiceRequest` protocol defines the interface for network requests. It includes the following properties:

- `path`: The path component of the URL.
- `method`: The HTTP method for the request.
- `headers`: Optional headers to be included in the request.
- `timeout`: Optional timeout interval for the request.
- `queryItems`: Optional query items for the URL.
- `body`: Optional body parameters for the request.

The `ServiceRequest` protocol provides default implementations for the `headers`, `timeout`, `queryItems`, and `body` properties. You can customize these properties in your specific request implementations.

#### Usage

```swift
class MyServiceRequest: ServiceRequest {
    
    var path: String {
        return "products"
    }
    
    var method: ServiceHTTPMethod {
        return .get
    }
}
```

<details>
  <summary>Complete cases</summary>
  
  ```swift
class MyServiceRequest: ServiceRequest {
    
    enum Request {
        case products
        case newProduct(product: MyProduct)
        case updateProduct(product: MyProduct, id: String)
        case deleteProduct(id: String)
    }
    
    let req: Request
    
    init(_ req: Request) {
        self.req = req
    }
    
    var path: String {
        switch req {
        case .products: return "products"
        case .newProduct: return "products/new"
        case .updateProduct(_, let id): return "products/\(id)"
        case .deleteProduct(let id): return "products/\(id)"
        }
    }
    
    var method: Service.ServiceHTTPMethod {
        switch req {
        case .products: return .get
        case .newProduct: return .post
        case .updateProduct: return .put
        case .deleteProduct: return .delete
        }
    }
    
    var body: [String : Any]? {
        switch req {
        case .newProduct(let product), .updateProduct(let product, _):
            return product.dictionary
        default:
            return nil
        }
    }
}
```
</details>

## ServiceSessionProtocol

The `ServiceSessionProtocol` protocol defines the interface for a service session. It includes the following properties and methods:

- `baseURL`: The base URL for the service session.
- `buildFinalPath(from request: ServiceRequest) -> String`: Builds the final URL path by combining the base URL and the request's path.

The `ApplicationServiceSession` struct is a concrete implementation of the `ServiceSessionProtocol`. It provides the base URL and implements the `buildFinalPath(from:)` method.

#### Usage
```swift
// Create a service session
struct MyServiceSession: ServiceSessionProtocol {
    var baseURL: String {
        return "https://api.example.com/"
    }
    
    func buildFinalPath(from request: ServiceRequest) -> String {
        return baseURL + request.path
    }
}
```

## NetworkServiceProtocol

The `NetworkServiceProtocol` protocol defines the interface for a network service. It includes the `fetch(_:from:completion:)` method for performing network requests.

## NetworkService

The `NetworkService` class is a concrete implementation of the `NetworkServiceProtocol`. It handles the execution of network requests and decoding the response data. It utilizes the `URLSession` and `Combine` frameworks for handling asynchronous operations and publishing results.

The `NetworkService` class manages a set of subscriptions to ensure they are cancelled appropriately.

To use the Service module, you can create a service session conforming to the `ServiceSessionProtocol` and pass it to an instance of the `NetworkService` class. Then, use the `fetch(_:from:completion:)` method to perform network requests and receive the results in the completion closure.

#### Usage
```swift
// Create an instance of NetworkService with the service session
let networkService = NetworkService(session: MyServiceSession())

// Perform a network request
networkService.fetch([Product].self, from: MyServiceRequest()) { result in
    switch result {
    case .success(let products):
        // Handle the retrieved products
        print(products)
    case .failure(let error):
        // Handle the error
        print(error.localizedDescription)
    }
}
```
