# Store Module

The Store module provides functionality for managing a store's products, cart, and related operations.

### Author

The Service module is developed and documented by Samuel Brasileiro.

**GitHub Account: https://github.com/samuelbrasileiro**

---

## Summary

- [Features](#features)
    - [Best Sellers](#best-sellers)
    - [Cart](#cart)
    - [Product Details](#product-details)
- [Models](#models)
    - [StoreCartProduct](#storecartproduct)
    - [StoreFilterKind](#storefilterkind)
    - [StoreProduct](#storeproduct)
    - [Observers](#observers)
        - [StoreCartObserver](#storecartobserver)
- [Providers](#providers)
    - [AddToCartProviderProtocol](#addtocartproviderprotocol)
    - [RetrieveCartCountProviderProtocol](#retrievecartcountproviderprotocol)
    - [UpdateCartProviderProtocol](#updatecartproviderprotocol)
    - [RetrieveCartProviderProtocol](#retrievecartproviderprotocol)
    - [StoreBestSellersProviderProtocol](#storebestsellersproviderprotocol)
- [Services](#service)
    - [Network Service](#network-service)
        - [StoreRequest](#storerequest)
        - [StoreBestSellersResponse](#storebestsellersresponse)
        - [StoreService](#storeservice)
    - [Cart Data Service](#cart-data-service)
        - [CartDataServiceProtocol](#cartdataserviceprotocol)
- [UI](#ui)
    - [Views](#views)
        - [StoreValueConfirmationView](#storevalueconfirmationview)
    - [Cells](#cells)
        - [StoreProductCell](#storeproductcell)
        - [StoreCartProductCell](#storecartproductcell)

---
# Features

## Best Sellers

#### Description
The Best Sellers feature presents a grid of the top-selling products in the store, allowing customers to easily explore and purchase popular items.

#### Requirements

- Customers can view a grid of best-selling products.
- Tapping on a product provides more detailed information about the item.
- Customers can filter the products based on the "in promotion" category.
- Products can be added to the cart, with the option to specify the desired size.
- Access to the cart is available by tapping the cart button located in the top right corner of the screen.

#### Route

`bestSellers`

#### Providers

- Add to Cart: Enables customers to add products to the cart.
- Retrieve Cart Count: Retrieves the total count of items in the cart.
- Best Sellers: Provides the list of best-selling products.

---

## Cart

#### Description

 The Cart feature allows customers to manage the products they have added to their cart.

#### Requirements

- Customers can view a list of products in their cart, along with their details.
- Tapping on a product within the cart provides more specific information about that product.
- Customers can adjust the quantity of each item using a stepper control.
- If the quantity of a product is set to zero, a confirmation alert is shown before removing the product from the cart.
- The accumulated total price of all products in the cart is displayed at the bottom of the screen.

#### Route 

`cart`

#### Providers

- Update Cart: Allows customers to update the quantities of products in the cart.
- Retrieve Cart: Retrieves the current state of the cart, including the list of products and their quantities.

---
## Product Details

#### Description

The Product Details feature provides customers with comprehensive information about a specific product.

#### Requirements

- Customers can access a screen dedicated to the detailed view of a particular product.
- The full image of the product is displayed, allowing customers to examine it in detail.
- Customers can add the product directly to their cart from the Product Details screen.
- Access to the cart is available by tapping the cart button located in the top right corner.

#### Route

 `productDetails(product: StoreProduct)`

#### Providers

- Add to Cart: Enables customers to add the selected product to their cart.
- Retrieve Cart Count: Retrieves the total count of items in the cart.

---

# Models

### StoreCartProduct

Represents a product in the store's cart.

#### Properties

- `chosenSize`: The chosen size of the product.
- `quantity`: The quantity of the product.
- `item`: The actual product item.

#### Static Properties

- `dirty`: A static property representing a dirty cart product with empty or default values.

#### Equatable

The `StoreCartProduct` struct conforms to the `Equatable` protocol.

---

### StoreFilterKind

Represents different kinds of filters for the store.

#### Cases

- `inPromotion`: Indicates that the filter is for products in promotion.

---

### StoreProduct

Represents a product in the store.

#### Properties

- `name`: The name of the product.
- `style`: The style of the product.
- `codeColor`: The color code of the product.
- `colorSlug`: The color slug of the product.
- `color`: The color of the product.
- `onSale`: A boolean value indicating if the product is on sale.
- `regularPrice`: The regular price of the product.
- `actualPrice`: The actual price of the product.
- `discountPercentage`: The discount percentage of the product.
- `installments`: The installments information for the product.
- `image`: The image URL of the product.
- `sizes`: An array of available sizes for the product.

#### Codable

The `StoreProduct` struct conforms to the `Codable` protocol.

#### Static Property

- `dirty`: A static property representing a dirty product with empty or default values.

---

##  Observers

### StoreCartObserver

A class for observing cart updates.

#### Properties

- `didUpdateCart`: A `PassthroughSubject` that sends a signal whenever the cart is updated.

#### Singleton

The `StoreCartObserver` class is a singleton.

---

# Providers

### AddToCartProviderProtocol

A protocol for providing functionality to add a product to the cart.

#### Methods

- `execute(product:completion:)`: Adds a product to the cart.

---

### RetrieveCartCountProviderProtocol

A protocol for providing functionality to retrieve the count of items in the cart.

#### Methods

- `execute(completion:)`: Retrieves the count of items in the cart.

---

### UpdateCartProviderProtocol

A protocol for providing functionality to update a product in the cart.

#### Methods

- `execute(product:completion:)`: Updates a product in the cart.

---

### RetrieveCartProviderProtocol

A protocol for providing functionality to retrieve the products in the cart.

#### Methods

- `execute(completion:)`: Retrieves the products in the cart.

---

### StoreBestSellersProviderProtocol

A protocol for providing functionality to retrieve the best-selling products.

#### Methods

- `execute(completion:)`: Retrieves the best-selling products.

---

# Services

## NetworkService

### StoreRequest

Represents a request to the store service.

#### Cases

- `bestSellers`: Indicates a request for retrieving the best-selling products.

#### Properties

- `path`: The endpoint path for the request.
- `method`: The HTTP method for the request.

---

### StoreBestSellersResponse

Represents the response for retrieving the best-selling products.

#### Properties

- `products`: An array of best-selling products.

#### Codable

The `StoreBestSellersResponse` struct conforms to the `Codable` protocol.

---

### StoreService

Provides functionality for interacting with the store's services.

#### Properties

- `networkService`: The network service used for making API requests.

#### Methods

- `getBestSellers(completion:)`: Retrieves the best-selling products.

---

## Cart Data Service

### CartDataServiceProtocol

A protocol for managing cart data.

#### Methods

- `add(product:)`: Adds a product to the cart.
- `update(product:)`: Updates a product in the cart.
- `getAll()`: Retrieves all products in the cart.
- `getCount()`: Retrieves the count of items in the cart.
- `clear()`: Clears the cart.

### CartDataService

Implements the `CartDataServiceProtocol` and manages cart data.

#### Properties

- `shared`: A shared instance of `CartDataService`.

#### Methods

- `add(product:)`: Adds a product to the cart.
- `update(product:)`: Updates a product in the cart.
- `getAll()`: Retrieves all products in the cart.
- `getCount()`: Retrieves the count of items in the cart.
- `clear()`: Clears the cart.

---

## UI

### Views
### StoreValueConfirmationView

`StoreValueConfirmationView` is a custom view that represents a confirmation section for displaying a price value.

#### UI Components

- `descriptionLabel: UILabel`: A label that displays the title of the view.
- `priceLabel: UILabel`: A label that displays the price text.
- `confirmationButton: UIButton`: A button that triggers the confirmation action.

#### Initializers

- `init()`: Initializes the view.

#### Public Methods

- `setup(descriptionText: String, buttonText: String)`: Configures the confirmation view with the provided title, and button text.

- `update(priceText: String)`: Updates price label's text

#### Actions

- `didTapCompleteButton(sender:)`: An action that is triggered when the confirm button is tapped.

#### Usage

Create an instance of `StoreValueConfirmationView`:

```swift
let confirmationView = StoreValueConfirmationView()
```

Configure the view with the desired title, price, and value:

```swift
confirmationView.configure(title: "Preço", buttonText: "Confirmar")
```

Update price label with desired string:

```swift
confirmationView.update(priceText: "R$ 120.00")
```

---

## Cells

### StoreProductCell

`StoreProductCell` is a custom collection view cell used to display a product in a store.

#### Public Properties

- `cellReuseIdentifier` (static): A static property that provides the reuse identifier for the cell.
- `tapAddToCartButton: PassthroughSubject<StoreProduct?, Never>`: A subject that emits the product when the add to cart button is tapped.
- `tapView: PassthroughSubject<StoreProduct?, Never>`: A subject that emits the product when the cell is tapped.
- `shimmeringAnimatedItems: [UIView]`: A computed property that returns an array of views that should animate the shimmer effect.

#### UI Components

- `productImageView: UIImageView`: An image view that displays the product image.
- `promoLabel: UILabel`: A padded label that displays "PROMO".
- `nameLabel: UILabel`: A label that displays the product name.
- `priceLabel: UILabel`: A label that displays the product price.
- `discountLabel: UILabel`: A label that displays the discounted price.
- `discountPercentageLabel: UILabel`: A label that displays the discount percentage.
- `installmentsLabel: UILabel`: A label that displays the product installments.
- `addToCartButton: UIButton`: A button to add the product to the cart.
- `sizesStack: UIStackView`: A stack view to display available sizes.

#### Initializers

- `init(frame: CGRect)`: Initializes the cell with the given frame.

#### Public Methods

- `setup(product: StoreProduct)`: Sets up the cell with the provided product.

#### Actions

- `didTapView`: Called when the cell is tapped.
- `didTapAddToCartButton(sender: UIButton)`: Called when the add to cart button is tapped.

#### Usage

Create an instance of `StoreProductCell`:

```swift
let cell = StoreProductCell(frame: .zero)
```

Set up the cell with a product:

```swift
let product = StoreProduct(name: "T-Shirt", actualPrice: "R$ 49.99", onSale: true, regularPrice: "R$ 59.99", discountPercentage: "20%", installments: "1x R$ 49.99", sizes: [StoreSize(size: "S", available: true), StoreSize(size: "M", available: true)], image: "https://example.com/product_image.jpg")
cell.setup(product: product)
```

---

### StoreCartProductCell

The `StoreCartProductCell` is a custom `UITableViewCell` subclass used to display a product item in a cart view. The cell also supports user interaction for updating the cart and viewing the product details.

#### Public Properties

- `cellReuseIdentifier` (static): A string value representing the reuse identifier for the cell.

- `tapUpdateCartButton`: A `PassthroughSubject` that emits a `StoreCartProduct` when the update cart button is tapped.

- `tapView`: A `PassthroughSubject` that emits a `StoreProduct` when the cell is tapped.

- `shimmeringAnimatedItems`: An array of `UIView` objects that participate in the shimmer animation effect.

#### UI Elements

- `productImageView`: An `UIImageView` used to display the product image.

- `nameLabel`: A `UILabel` used to display the product name.

- `priceLabel`: A `UILabel` used to display the chosen product price.

- `discountLabel`: A `UILabel` used to display the discounted price when the product is on sale.

- `sizeLabel`: A custom `CorePaddedLabel` used to display the product size.

- `countStepper`: A `UIStepper` used to adjust the quantity of the product.

- `countLabel`: A `UILabel` used to display the current quantity of the product.

#### Initializers

- `init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)`: Initializes the cell with a specific style and reuse identifier. This is the designated initializer for the class.

#### Public Methods

- `setup(product: StoreCartProduct)`: Configures the cell with a `StoreCartProduct` object. It sets up the UI elements with the corresponding product information.

#### Actions

- `stepperDidChange(sender: UIStepper)`: An action method called when the value of the `countStepper` changes. It updates the product quantity, updates the count label, and sends the updated product via the `tapUpdateCartButton` subject. If the stepper value reaches 0, it sets the quantity to 1 as the minimum value.

- `didTapView()`: An action method called when the cell is tapped. It sends the associated product's details via the `tapView` subject.