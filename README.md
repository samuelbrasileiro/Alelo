# Alelo Challenge

Welcome to the project! The Alelo Challenge is a mobile application that aims to provide a solution for managing shopping activities, including product browsing, adding items to the shopping cart, and processing orders. The app is designed to enhance the user experience and simplify the shopping process.

### Author

The project is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

---

## Summary
- [Running Locally](#running-locally)
    - [Setting up the environment](#setting-up-the-environment)
    - [Creating Project](#creating-project)
- [Packages](#packages)
    - [Commons](/Commons/README.md)
    - [Dependency Injection](/DependencyInjection/README.md)
- [Modules](#modules)
    - [Service](/Service/README.md)
    - [Core](/Core/README.md)
    - [Store](/Service/README.md)
- [Tests](#tests)
- [Visualizing Dependency Graph](#visualizing-dependency-graph)
- [Coding Patterns](#coding-patterns)
---

## Running Locally

To run the project locally, follow the setup instructions below.

### Setting up the environment

Before running the project, you need to set up the necessary tools and dependencies.


1. Install the latest version of [XcodeGen](https://github.com/yonaskolb/XcodeGen) using Homebrew:
    ```bash
    brew instal xcodegen
    ```

2. Install the latest version of [SwiftGen](https://github.com/SwiftGen/SwiftGen) using Homebrew:
    ```bash
    brew instal swiftgen
    ```

### Creating Project

To create and run the project locally, perform the following steps:

1. Clone the project repository:
    ```bash
    git clone https://github.com/samuelbrasileiro/AleloChallenge.git
    ```

2. Navigate to the project directory:
    ```bash
    cd AleloChallenge
    ```

3. Generate the AleloChallenge's xcodeproj using XcodeGen:
    ```bash
    make project
    ```

4. Open the generated xcodeproj file and build and run the project.

---

## Packages

The project uses some packages that provide different functionalities and features. Below are the descriptions of the packages:

1. Commons

    The `Commons` package provides reusable code snippets for iOS development. It includes common utility functions, extensions, and custom UI components that can be used across different modules of the project.
    
    **[Read Documentation](Commons/README.md)**

2. DependencyInjection

    The `DependencyInjection` package is a custom implementation of a dependency injection framework for Swift. It provides a way to manage dependencies and promote modularity and testability in the project. The package includes components and protocols for defining and injecting dependencies in a decoupled manner.
    
    **[Read Documentation](DependencyInjection/README.md)**

3. SDWebImage

    The **[SDWebImage](https://github.com/SDWebImage/SDWebImage)** package is a widely used library for efficiently downloading and caching remote images asynchronously. It provides an easy-to-use API for loading images from URLs and handling caching and placeholder images.
    
4. UIView_Shimmer

    The **[UIView_Shimmer](https://github.com/omerfarukozturk/UIView-Shimmer)** package provides a shimmer effect animation for UIView components. It allows you to add a shimmering effect to any UIView, giving a smooth and eye-catching animation while data is loading or to indicate activity.

---

## Modules

The Alelo Challenge project is organized into different modules, each serving a specific purpose and providing essential functionalities for the application. Below are the descriptions of the modules:

1. Service

    The Service module provides a set of components and protocols for performing network requests. It includes networking utilities, request builders, and response handlers to simplify the process of making API calls and handling responses.
    
    **[Read Documentation](Service/README.md)**
    
2. Core

    The `Core` module provides essential functionalities and components to create the main structures of the project. It includes common UI components, coordinators, and utility classes that facilitate the implementation of the project's flow and navigation.
    
    **[Read Documentation](Core/README.md)**
    
3. Store

    The `Store` is responsible for managing the shopping-related functionality of the application. It includes views, view controllers, coordinators, providers, and network requests necessary for handling the shopping flow. The module focuses on presenting and managing the user interface components related to shopping, such as product listings, shopping cart management, and order processing.
    
    **[Read Documentation](Store/README.md)**

4. ModuleIntegration

    The `ModuleIntegration` module facilitates the integration of various modules within the Alelo Challenge application. It provides a centralized mechanism for coordinating the interactions between different modules, enabling seamless communication and data exchange. This module ensures proper integration and collaboration among different components of the application.
    
5. Application

    The `Application` module represents the main entry point of the application. It includes the app delegate, scene delegates, and other necessary configurations for initializing and setting up the application. This module acts as the glue that brings all other modules together and starts the application's execution.

---

## Tests

The project includes various test suites to ensure the correctness and stability of the codebase. Below are the descriptions of the test suites:

1. ServiceTests
    
    The `ServiceTests` suite contains unit tests for the Service module. It includes test cases to validate the networking fetch component.
    
2. StoreTests
    
    The `StoreTests` suite contains unit tests for the Store module. It includes test cases to validate the views, data view models and data manipulation layers.
    
3. Dependency Injection
    
    The `DependencyInjectionTests` suite contains unit tests for the DependencyInjection module. It includes test cases to ensure the correct configuration and injection of dependencies in the project.


---

## Visualizing Dependency Graph

To visualize the dependency graph of the Alelo Challenge project locally, follow the steps below:

1. Run the following command to generate the dependency graph image:

    ```bash
    make graph
    ```

    **Note:** It's necessary to have [Graphviz](https://graphviz.org/) visualization software installed on your machine to generate the graph image. If you don't have Graphviz installed, run the following command to install it using Homebrew:

    ```bash
    brew instal graphviz
    ```
2. After running the command, the dependency graph image will be generated and displayed.

    ![Dependency Graph Image](/public/images/dependency_graph.png "Dependency Graph Image")

---

## Coding Patterns

1. Modularity
    
    The project is developed with a modular approach, where each module has a clearly defined responsibility and is independent from others. This allows for proper separation of functionalities and better code organization.

2. Architecture

    Alelo Challenge follows an **MVVM (Model-View-ViewModel)** based architecture. The MVVM architecture is an approach that separates the presentation logic from the user interface, facilitating code testability, reusability, and maintainability. In this architecture, the Model layer represents the data and business rules, the View layer is responsible for displaying the user interface, and the ViewModel layer acts as a bridge between the data and the user interface.

3. Project Generation

    **XcodeGen** is a tool used in the project to generate the .xcodeproj file from a YAML configuration file. It simplifies the project configuration process by automating the creation of targets, schemes, and other Xcode-related settings, making continuous collaboration easier. 

4. Resources Generation
   
   **SwiftGen** is a tool used in the project to generate typed Swift code for resources such as images, strings, fonts, and colors. It analyzes the project's resource files and generates a series of enums and extensions that facilitate safe and typo-free access to resources.

5. Protocol Oriented Programming

    The project utilizes the **Protocol-Oriented Programming** code pattern. POP allows for the creation of more generic, reusable, and flexible code by promoting code composition and modularity.

6. Use Cases
   
    Use cases (providers) are used to decouple the usage rules from the View Models, achieving a more flexible architecture.

7. Clean Code

    The Alelo Challenge project is developed based on the principles of **Clean Code**, which emphasize the readability, simplicity, and maintainability of the code. The code have atomic and cohesive functions and classes, descriptive names for variables and methods, avoiding duplication, and maintaining an easily understandable structure.