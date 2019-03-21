# KeyboardLock

![Preview][preview]

[preview]: /Images/preview.gif "Preview"

[![CI Status](https://img.shields.io/travis/nathan-fiscaletti/KeyboardLock.svg?style=flat)](https://travis-ci.org/nathan-fiscaletti/KeyboardLock)
[![Version](https://img.shields.io/cocoapods/v/KeyboardLock.svg?style=flat)](https://cocoapods.org/pods/KeyboardLock)
[![License](https://img.shields.io/cocoapods/l/KeyboardLock.svg?style=flat)](https://cocoapods.org/pods/KeyboardLock)
[![Platform](https://img.shields.io/cocoapods/p/KeyboardLock.svg?style=flat)](https://cocoapods.org/pods/KeyboardLock)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```swift
KeyboardLock(
    withView: containerView,
    andLockType: .BottomConstraint
).lock()
```

> When using `.BottomConstraint` or `.HeightConstraint`, you can either pass the constraint you wish to update manually using `withConstraint:` in the constructor, or you can leave it blank and the system will attempt to ind the constraint itself.

## Installation

KeyboardLock is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'KeyboardLock'
```

## Author

nathan-fiscaletti, nathan.fiscaletti@gmail.com

## License

KeyboardLock is available under the MIT license. See the LICENSE file for more info.
