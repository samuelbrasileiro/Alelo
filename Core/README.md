# Core Module

The Core Module provides essential functionalities and components for building robust and scalable applications.

### Author

The Core module is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

---
## Flow

The Flow component in the Core Module is responsible for managing the navigation and coordination of different screens or modules within an application.

### Coordinator

The `Coordinator` protocol defines the behavior of a coordinator.

#### Properties

- `navigationController`: The navigation controller associated with the coordinator.
- `parentCoordinator`: The parent coordinator.
- `childCoordinators`: The child coordinators.

#### Methods

- `init(resolver:navigationController:)`: Initializes the coordinator with a dependency resolver and a navigation controller.
- `start()`: Starts the coordinator.
- `removeCoordinator(_:)`: Removes a child coordinator.

#### Usage
```swift
let resolver = MyDependencyResolver()
let navigationController = UINavigationController = ()
let coordinator = MyCoordinator(resolver: resolver, navigationController: navigationController)
coordinator.start()
```

### Navigatable

The `Navigatable` protocol defines navigation behavior.

#### Associated Types

- `Route`: The type representing the navigation route.

#### Methods

- `navigate(to:)`: Navigates to the specified route.
- `goBack(animated:)`: Navigates back.

#### Usage
```swift
let route: MyRoute = ...
self.navigate(to: route)
self.goBack(animated: true)
```

### Routable

The `Routable` protocol defines the behavior of an object that contains a route.

#### Associated Types

- `Route`: The type representing the route.

#### Methods

- `getTransition(to:)`: Returns the view controller associated with the specified route.

#### Usage
```swift
let route: MyRoute = ...
let viewController = getTransition(to: route)
```

---

## UI

The UI component in the Core Module consists of reusable UI elements and base classes that can be used to build the user interface of an application.

### CoreSceneDelegate

The `CoreSceneDelegate` class is a base class for scene delegates.

#### Properties

- `window`: The window associated with the scene.
- `coordinator`: The coordinator associated with the scene.

#### Methods

- `scene(_:willConnectTo:options:)`: Called when the scene is about to connect to the session.
- `setupEnvironment()`: Sets up the environment to create flow.

#### Usage
```swift
public class MySceneDelegate: CoreSceneDelegate {
    public override func setupEnvironment() {
        let navigationController = UINavigationController()
        let resolver = MyDependecyResolver()
        let coordinator = MyCoordinator(resolver: resolver, navigationController: navigationController)
        coordinator.start()
        self.coordinator = coordinator
    }
}
```

### CoreBarButtonItem

The `CoreBarButtonItem` class is a custom bar button item.

#### Properties

- `badgeValue`: The badge value to display.

#### Methods

- `init(image:target:action:)`: Initializes the bar button item with an image, target, and action.

#### Usage
```swift
let image: UIImage? = ...
let action: Selector = ...
let barButtonItem = CoreBarButtonItem(image: image, target: self, action: action)
```

### CorePaddedLabel

The `CorePaddedLabel` class is a padding-settable label.

#### Properties

- `padding`: The padding around the label content.

#### Usage
```swift
let label = CorePaddedLabel()
label.padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
```

---
## Domain

The Domain component in the Core Module encapsulates the core business logic and entities of the application.

### CoreImage

The `CoreImage` enum provides image assets used in the Core module.

#### Usage
```swift
let image = CoreImage.unavailableImage.image
```
#### Images

- `unavailableImage`: An unavailable image asset. 
<img src="Core/Resources/Assets.xcassets/unavailable-image.imageset/imagem-indisponível.jpg" alt="UnavailableImage" width="80" height="80">

---
## Extensions

The Extensions component in the Core Module contains extensions for existing classes or structures, providing additional functionality.

### UIViewController+showError

The extension `UIViewController+showError` extends `UIViewController` to display an error message.

#### Usage
```swift
let error: Error = ...
self.showError(error)
```