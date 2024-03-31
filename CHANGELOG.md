# CHANGELOG

[Changelog](https://github.com/dominicstop/react-native-ios-utilities/blob/master/CHANGELOG.md) for [`react-native-ios-utilities`](https://github.com/dominicstop/react-native-ios-utilities).

<br>

## v4.4.6

* **Releases**: [v4.4.6-0](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.6-0) ([changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.5...v4.4.6-0))
* **Summary**: TBA

<br><br>

## v4.4.5

* **Release**: [v4.4.5](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.5) | [changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.4...v4.4.5)
* **Summary**: Merge [PR #2](https://github.com/dominicstop/react-native-ios-utilities/pull/2) (by [Albert Gao](https://github.com/Albert-Gao))
  * Fix: Unexpectedly found nil while implicitly unwrapping an Optional

<br><br>

## v4.4.4

* **Release**: [v4.4.4](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.4) | [changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.3...v4.4.4)
* **Summary**: Update view cleanup logic.
  * Fix view cleanup logic being disabled on subsequent app reloads.
  * `RNICleanableViewRegistryEnv` - Add `shouldUseUIManagerQueueForCleanup` option to `setSharedEnvForRNICleanableViewRegistry`.


<br><br>

## v4.4.3

* **Release**: [v4.4.3](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.3) | [changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.2...v4.4.3)
* **Summary**: Update cleanup logic to fix crash when the app is being reloaded

<br><br>

## v4.4.2

* **Release**: [v4.4.2](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.2) | [changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.1...v4.4.2)
* **Summary**: Refactor cleanup logic in `RNICleanableViewRegistry` to use queue.
  * Recursively get items to clean, and add items to a queue that strongly retains the delegates.
  * Schedule cleanup in `UIManager`, and recursively dequeue cleanup items.
  * Re-enable cleanup logic via `RNICleanableViewRegistryEnv`'s `shouldGloballyDisableCleanup` flag.

<br>

## v4.4.1

* **Release**: [v4.4.1](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.1) | [changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.0...v4.4.1)
* **Summary**: Globally disable cleanup logic via `RNICleanableViewRegistryEnv`'s `shouldGloballyDisableCleanup` flag as a temp. emergency fix for crashes.

<br>

## v4.4.0

* **Release**: [v4.4.0](https://github.com/dominicstop/react-native-ios-utilities/releases/tag/v4.4.0) | [current changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.4.0-6...v4.4.0) | [all changes](https://github.com/dominicstop/react-native-ios-utilities/compare/v4.3.2...v4.4.0)
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
