# SwipeableViewController

[![Version](https://img.shields.io/cocoapods/v/SwipeableViewController.svg?style=flat)](http://cocoapods.org/pods/SwipeableViewController)
[![License](https://img.shields.io/cocoapods/l/SwipeableViewController.svg?style=flat)](http://cocoapods.org/pods/SwipeableViewController)
[![Platform](https://img.shields.io/cocoapods/p/SwipeableViewController.svg?style=flat)](http://cocoapods.org/pods/SwipeableViewController)

## Example

To run the example project, clone the repo and build.

## Requirements

- iOS 9
- Swift 4

## Installation

SwipeableViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwipeableViewController'
```

## Usage
```swift
// Make an instance of SwipeableNavigationController
let navigationController = SwipeableNavigationController(navigationBarClass: SwipeableNavigationBar.self, toolbarClass: nil)

// Make an instance of SwipeableViewController
let viewController = SwipeableViewController()

// Inject data
viewController.swipeableItems = [SwipeableItem(title: "View 1", viewController: ExampleViewController()),
                                 SwipeableItem(title: "View 2", viewController: ExampleViewController()),
                                 SwipeableItem(title: "View 3", viewController: ExampleViewController())]
viewController.selectedIndex = 1

// Set the view to the navigation controller (if you want the SwipeableViewController at the root of your navigationController)
navigationController.setViewControllers([viewController], animated: false)
```

And you're good to go!

## Author

Oscar Apeland, oscar@tiseit.com

## License

SwipeableViewController is available under the MIT license. See the LICENSE file for more info.
