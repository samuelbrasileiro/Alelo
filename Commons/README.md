# Commons Package

The Commons package provides a collection of commonly used utility extensions and functions for iOS development. These utilities aim to simplify and enhance the development process by providing reusable code snippets.

### Author

The Commons package is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

---
### UIStackView+removeAllArrangedSubviews

This extension adds a convenient method to `UIStackView` that allows you to remove all arranged subviews from the stack view.

#### Usage

```swift
stackView.removeAllArrangedSubviews()
```

---
### Collection+safeSubscript

This extension adds a subscript to `Collection` that allows for safe access to elements based on an index. It returns the element at the specified index if it exists, or `nil` otherwise.

#### Usage

```swift
let element = collection[safe: index]
```