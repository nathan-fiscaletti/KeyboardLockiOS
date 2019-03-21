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

### Lock Types

|Lock Type|Description|Constraint Search Criteria|
|---|---|---|
|`.BottomConstraint`|The bottom constraint will be moved up based on the height of the keyboard at the end of it's animation cycle.|`superView.constraints.firstAttribute == .bottom && superview.constraints.relation == .equal`|
|`.HeightConstraint`|The height of the constraint will be shortened based on the height of the keyboard at the end of it's animation cycle.|`view.constraints.firstAttribute == .height && view.constraints.relation == .equal`|
|`.FrameOrigin`|The Y origin point of the views frame will be moved up based on the height of the keyboard at the end of it's animation cycle.|None|

### Other Notes

1. When using `.BottomConstraint` or `.HeightConstraint`, you can either pass the constraint you wish to update manually using `andConstraint:` in the constructor, or you can leave it blank and the system will attempt to find the constraint itself. If it cannot find the proper constraint, a warning message will be sent through `NSLog`.
2. You can unlock a view from the keyboard using the `.unlock()` member function of the associated `KeyboardLock` instance.

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
