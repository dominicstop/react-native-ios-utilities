# react-native-ios-utilities

hello, this is a helper library, and doesn’t really do anything on it’s own. This library is meant to be used as a dependency for other libraries — i.e. as a way to share code, and prevent duplicated logic.

Please see the [version compatibility](#version-compatibility) table for reference.

<br><br>

## 🚧⚠️ Re-Write WIP 🚧⚠️

This library is being re-written to support both the new + old architecture. Please see this is [issue](https://github.com/dominicstop/react-native-ios-context-menu/issues/100#issuecomment-2077986438) for progress 😔

**Overview**:

- [`RNIBaseView`](ios/Sources/RNIBaseView): A shared/common “base view” to allow for making native components that work on both fabric (the new architecture) and paper (please see: [`RNIWrapperView`](ios/Sources/RNIWrapperView) for an example implementation).
- [`RNIContentViewDelegate`](ios/Sources/RNIContentView/RNIContentViewDelegate.swift): A delegate that let’s the conforming `UIView` (written in swift) to manage + communicate with its associated parent fabric/paper view, and handle layout, receive props + async view commands from JS, and dispatch events from native.
- [`RNIViewLifecyleEvent`](ios/Sources/RNIViewLifecycle): a set of delegates for receiving common view lifecycle events between fabric + paper, as well as receiving events that are either fabric-only or paper-only. Please see [`RNIBaseViewEventBroadcaster`](ios/Sources/RNIBaseView/RNIBaseViewEventBroadcaster.swift) for an overview of what events are supported.
- [`RNIContentViewParentDelegate`](): Exposes useful properties and methods from the parent paper/fabric view (e.g. controlling size/layout, getting the layout metrics, etc).
- [`RNIBaseViewController`](ios/Sources/RNIBaseView/RNIBaseViewController.swift): A base implementation of a view controller that wraps a paper/fabric view and handles its sizing + layout when attached to non-react view.
- [`RNIUtilitiesModule`](src/native_modules/RNIUtilitiesModule/RNIUtilitiesModule.ts): A helper JSI module that allows for sharing sync data between swift and js, and sending async commands to either views that conform to `RNIContentViewDelegate`, or objects that conform to [`RNIModuleCommandRequestHandling `](ios/Sources/RNIUtilitiesModule/RNIModuleCommandRequestHandling.swift) (please see the [js](src/native_components/RNIDummyTestView/RNIDummyTestViewModule.ts) + [swift](ios/Sources/RNIDummyTestView/RNIDummyTestViewModuleRequestHandler.swift) impl. of `RNIDummyTestViewModule` for a crude example).

- **Types and Parsing**: Contains [typescript definitions](src/types) for native types (e.g. `UIKit`, `CoreGraphics` primitives, etc) so they can be represented in JS, as well as the associated code to parse them in native (e.g. [`InitializableFromDictionary`](ios/Sources/Extensions+InitializableFromDictionary), [`InitializableFromString`](ios/Sources/Extensions+InitializableFromString), dictionary helpers, etc).
- **Misc**: Contains a bunch of helpers + extensions for working with RN across swift/objc/c++, and has a dependency to [`DGSwiftUtilities`](https://github.com/dominicstop/DGSwiftUtilities/tree/main/Sources) for more helpers + utilities written in swift.

<br><br>

## Acknowledgements

Development and maintenance of this library was generously sponsored by [beatgig](https://beatgig.com/) from `11/15/2023` to ` 04/30/2024` at `$1,535`/month (totaling ≈ `$9,100` over the course of 6 months) 🥁🎸

<br>

The initial fabric rewrite (i.e. version `5.x`) was made possible through a generous `$3,750` sponsorship by [natew](https://github.com/natew) + [tamagui](https://github.com/tamagui/tamagui) over the course of 4 months (from: `05/27/24` to `09/30/24`) 🐦✨

<br>

very special thanks to: [junzhengca](https://github.com/junzhengca), [brentvatne](https://github.com/brentvatne), [expo](https://github.com/expo), [EvanBacon](https://github.com/EvanBacon), [corasan](https://github.com/corasan), [lauridskern](https://github.com/lauridskern), and [ronintechnologies](https://github.com/ronintechnologies) for becoming a monthly sponsor and [fobos531](https://github.com/fobos531) for being a one time sponsor 🥺 (if you have the means to do so, please considering sponsoring [here](https://github.com/sponsors/dominicstop))

<br><br>

## Installation

```sh
npm install react-native-ios-utilities@next
cd ios && pod install
```

<br><br>

## Version Compatibility

| Library Version                                       | Child Libraries / Dependents                                 |
| ----------------------------------------------------- | :----------------------------------------------------------- |
| `react-native-ios-utilities`<br/>**Version**: `4.3.x` | `react-native-ios-context-menu`<br/>**Version**: `2.4.x`<br/><br/>`react-native-text-input-wrapper`<br/>**Version**: `0.1.x`<br><br>`react-native-ios-adaptive-modal`<br/>**Version**: `0.6.x`<br> |
| `react-native-ios-utilities`<br>**Version**: `4.4.x`  | `react-native-ios-context-menu`<br/>**Version**: `2.5.x`<br/><br/>`react-native-text-input-wrapper`<br/>**Version**: `0.1.x`<br/><br/>`react-native-ios-adaptive-modal`<br/>**Version**: `0.7.x`<br> |
| `react-native-ios-utilities`<br/>**Version**: `5.x`   | `react-native-ios-context-menu`<br/>**Version**: `3.x`<br/><br>`react-native-ios-visual-effect-view`<br>**Version**: `0.x` |



<br><br>

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

<br><br>

## License

MIT
