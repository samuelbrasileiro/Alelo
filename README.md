# Alelo Challenge

Welcome to the project! The Alelo Challenge is a mobile application that aims to provide a solution for managing shopping activities, including product browsing, adding items to the shopping cart, and processing orders. The app is designed to enhance the user experience and simplify the shopping process.

### Author

The project is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

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

1. DependencyInjection
The `DependencyInjection` package is a custom implementation of a dependency injection framework for Swift. It provides a way to manage dependencies and promote modularity and testability in the project. The package includes components and protocols for defining and injecting dependencies in a decoupled manner.
**[Read Documentation](DependencyInjection/README.md)**
1. SDWebImage
The **[SDWebImage](https://github.com/SDWebImage/SDWebImage)** package is a widely used library for efficiently downloading and caching remote images asynchronously. It provides an easy-to-use API for loading images from URLs and handling caching and placeholder images.
1. UIView_Shimmer
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
1. Store
The `Store` is responsible for managing the shopping-related functionality of the application. It includes views, view controllers, coordinators, providers, and network requests necessary for handling the shopping flow. The module focuses on presenting and managing the user interface components related to shopping, such as product listings, shopping cart management, and order processing.
1. ModuleIntegration
The `ModuleIntegration` module facilitates the integration of various modules within the Alelo Challenge application. It provides a centralized mechanism for coordinating the interactions between different modules, enabling seamless communication and data exchange. This module ensures proper integration and collaboration among different components of the application.
1. Application
The `Application` module represents the main entry point of the application. It includes the app delegate, scene delegates, and other necessary configurations for initializing and setting up the application. This module acts as the glue that brings all other modules together and starts the application's execution.

---

## Tests

The project includes various test suites to ensure the correctness and stability of the codebase. Below are the descriptions of the test suites:

1. ServiceTests
The `ServiceTests` suite contains unit tests for the Service module. It includes test cases to validate the networking fetch component.
2. StoreTests
The `StoreTests` suite contains unit tests for the Store module. It includes test cases to validate the views, data view models and data manipulation layers.
1. Dependency Injection
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