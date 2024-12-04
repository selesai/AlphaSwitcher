# AlphaSwitcher Documentation

## Overview

`AlphaSwitcher` is a customizable switch component designed for iOS. It allows you to easily integrate a toggle switch with various styling options, including background color, border, corner radius, icons, and titles.

<video controls>
  <source src="demo.mp4" type="video/mp4">
</video>

## Requirements

- Xcode 11 or later
- iOS 13.0 or higher
- Swift 5.0 or higher

## Installation
### Manual Installation
Drag and drop `AlphaSwitcher.swift` into your Xcode project.

### CocoaPods
To install `AlphaSwitcher` using CocoaPods, add the following line to your `Podfile`:

```ruby
pod 'AlphaSwitcher'
```

Then, run:
```
pod install
```

### Swift Package Manager (SPM)
To install AlphaSwitcher using SPM, add the following dependency to your Package.swift file:
```
.package(url: "https://github.com/selesai/AlphaSwitcher.git", from: "1.0.0")
```

Or add it via Xcode’s “Add Package Dependency” dialog.

## Usage
After installation, you can start using the AlphaSwitcher like so:
```swift
let switcher = AlphaSwitcher()
```

Add the switcher to your view and customize it according to your needs.

## Customization
You can customize the appearance of the `AlphaSwitcher` using the `Configuration` struct. The `Configuration` struct allows you to define the appearance of the background, foreground, border, and corner radius.
```swift
let background = AlphaSwitcher.Configuration.Background(
    colorOn: UIColor(red: 0.0, green: 101.0 / 255.0, blue: 209.0 / 255.0, alpha: 1.0),
    colorOff: UIColor(red: 231.0 / 255.0, green: 231.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
)

let foreground = AlphaSwitcher.Configuration.Foreground(
    colorOn: .white,
    colorOff: .gray
)

let border = AlphaSwitcher.Configuration.Border(
    colorOn: .clear,
    colorOff: UIColor(red: 13.0 / 255.0, green: 17.0 / 255.0, blue: 23.0 / 255.0, alpha: 0.05)
)

let configuration = AlphaSwitcher.Configuration(
    background: background,
    foreground: foreground,
    border: border,
    cornerRadius: 10
)

switcher.setConfiguration(configuration: configuration)
// or
switcher.configuration = configuration
```

#### Properties:
- Background: Customize the background colors for the on and off states.
    - colorOn: Background color when the switch is on.
    - colorOff: Background color when the switch is off.
- Foreground: Customize the foreground colors (e.g., the icon or title) for the on and off states.
    - colorOn: Foreground color when the switch is on.
    - colorOff: Foreground color when the switch is off.
- Border: Customize the border colors for the on and off states.
    - colorOn: Border color when the switch is on.
    - colorOff: Border color when the switch is off.
- Corner Radius: Adjust the corner radius for rounded edges of the switch.

#### Title and Icon
- Icon: Set an image for the switch.
```swift
switcher.setIcon(
    icon: AlphaSwitcher.Icon(
        iconOn: .add.withRenderingMode(.alwaysTemplate),
        iconOff: .remove.withRenderingMode(.alwaysTemplate)
    )
)
```

- Title: Set the title text for the switch.
```swift
switcher.setTitle(
    title: AlphaSwitcher.Title(
        titleOn: "Y",
        titleOff: "N"
    )
)
```

## Events
AlphaSwitcher detects user interactions and state changes:
- Tap event: The switcher will trigger an event when tapped.
```swift
switcher.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)
```

You can handle the state change in the switchToggled method:
```swift
@objc
func switchToggled(_ sender: AlphaSwitcher) {
    if switcher.isOn {
        // Handle the switch being on
    } else {
        // Handle the switch being off
    }
}
```

- State change: The `isOn` property tracks whether the switch is on or off.
```swift
if switcher.isOn {
    print("The switch is ON")
} else {
    print("The switch is OFF")
}
```


## License
AlphaSwitcher is licensed under the MIT License. See the LICENSE file for more details.
