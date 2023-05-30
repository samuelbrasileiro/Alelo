# Dependency Injection Package

The Dependency Injection package provides a flexible mechanism for managing dependencies in software applications. It helps decouple components and promotes code reusability, testability, and maintainability.

###Author

The Dependency Injection package is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

## Overview

The Dependency Injection (DI) pattern revolves around the concept of inverting the control of object creation and management. Instead of each component creating its dependencies directly, dependencies are injected from external sources. This approach reduces tight coupling between components and allows for easier modification and substitution of dependencies.

The Dependency Injection package consists of several key components:

- **Assembler:** The `Assembler` class serves as the entry point for configuring and managing dependencies. It maintains a `DependencyContainer` and provides methods for adding contents to the container.
- **Assembly:** The `Assembly` protocol defines the interface for configuring dependencies. It includes the `assemble(container:)` method, which is implemented by individual assemblies to register dependencies in the container.
- **DependencyGraph:** The `DependencyGraph` protocol represents a collection of assemblies. It defines the `build()` method, which returns an array of assemblies to be added to the container.
- **DependencyContainer:** The `DependencyContainer` class is responsible for storing and resolving dependencies. It maintains a dictionary of dependencies and provides methods for registering and resolving them.
- **DependencyResolver:** The `DependencyResolver` protocol defines the interface for resolving dependencies. It includes the `resolve(_:argument:)` method, which is used to retrieve dependencies from the container.

## Usage

To use the Dependency Injection package, you typically create an instance of the `Assembler` class and configure it with the necessary dependencies. You can define your assemblies conforming to the `Assembly` protocol and add them to the assembler using the `addContents(of:)` method. The assembler then assembles the container, and you can use the container's `resolve()` method to retrieve dependencies when needed.

#### Register

The `assemble(container:)` method of the assembly is called by the assembler to register dependencies in the container. In this example, we register `MyService` with its dependency resolved using the resolver.

```swift
// Define an assembly that conforms to the Assembly protocol
class MyAssembly: Assembly {
    func assemble(container: DependencyContainer) {
        // Register dependencies in the container
        container.register(MyService.self) { resolver in
            let dependency = resolver.resolve(MyDependency.self)
            return MyService(dependency: dependency)
        }
    }
}
// Create a dependency graph containing necessary assemblies
class MyDependencyGraph: DependencyGraph {
    func build() -> [Assembly] {
        return [MyAssembly()]
    }
}

// Create an instance of the Assembler and add the contents of the graph
let assembler = Assembler()
assembler.addContents(of: MyDependencyGraph())
```

#### Resolver

After adding the contents of the assembly to the assembler, we can obtain a resolver from the assembler. The `resolve(_:)` is responsible for resolving dependencies registered in the container.

```swift
let assembler = Assembler()
assembler.addContents(of: MyDependencyGraph())
let resolver = assembler.resolver

let myService: MyService = resolver.resolve(MyService.self)
```
####  Arguments
If your dependency requires additional arguments during initialization, you can pass them to the registration closure. Similarly, when resolving the dependency, you can provide the required arguments using `resolve(_:argument:)`.

```swift
container.register(MyService.self) { (resolver, argument: String) in
    let dependency = resolver.resolve(MyDependency.self)
    return MyService(dependency: dependency, argument: argument)
}

let myService: MyService = resolver.resolve(MyService.self, argument: "Argument")
```

In this example, we register `MyDependency` and `MyService` with an argument. When resolving `MyService`, we provide the required `String` argument "Argument".