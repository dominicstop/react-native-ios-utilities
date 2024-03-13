# CHANGELOG

[Changelog](https://github.com/dominicstop/react-native-ios-utilities/blob/master/CHANGELOG.md) for [`react-native-ios-utilities`](https://github.com/dominicstop/react-native-ios-utilities).

<br>

## v4.4.0

* **Release**: [v4.4.0](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.0-6) | [current changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.0-6...v4.4.0) | [all changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.3.2...v4.4.0)
* **Summary**: Finalized release for `v4.4.0`.
  * Impl. of new view cleanup logic: `RNICleanableView` (replacement for `RNICleanup`) - Cleanup logic is now shared + coordinated amongst views that conform to `RNICleanableViewDelegate` via the `RNICleanableViewRegistry` singleton.
  * Updated `RNIHelpers.recursivelyRemoveFromViewRegistry` logic - Use the built-in private function from RN internals + fallback (in case of unavailability).
  * Deprecated `RNICleanupMode` + related sources.
  * Update `RNIDetachedView` to use the new cleanup logic.
  * Impl. of  `RNIUtilitiesModule` + `RNIUtilitiesManagerEventsNotifiable` - Allows for singletons that conform to `RNIUtilitiesManagerEventsNotifiable` to get notified of `RNIUtilitiesModule`-related events (e.g. `notifyOnJavascriptModuleDidLoad`, `notifyOnSharedEnvDidUpdate`).
  * Impl. `RNIUtilitiesModuleEnv` - Global flags to control debugging, logging and cleanup logic.
  * Bump min. version dependency to `DGSwiftUtilities` from `0.12` to `0.17`.

<br>

## v4.4.0-6

* **Release**: [v4.4.0-6](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.0-6) | [current changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.0-5...v4.4.0-6) | [all changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.3.2...v4.4.0-6)
* **Summary**: Consolidate view cleanup types - Add `RNIViewCleanupModeProp`, and update `RNIDetachedView` to use  `RNIViewCleanupModeProp` for defining `RNIDetachedView.internalViewCleanupMode` prop.

<br>

## v4.4.0-5

* **Release**: [v4.4.0-5](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.0-5) | [current changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.0-4...v4.4.0-5) | [all changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.3.2...v4.4.0-5)
* **Summary**: Update cleanup logic in `RNICleanableViewRegistry` and `RNIHelpers`.
