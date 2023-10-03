



| Library            | Current Version | Next Version                                                 |
| ------------------ | --------------- | ------------------------------------------------------------ |
| `rni-context-menu` | `1.15.3`        | `1.x` -> `5.0`<br><br>skip: `2.x`, `3.x`, `4.x`<br>`5.0`: peer dep to `rni-util` <br>`5.0`: fabric/jsi |
| `rni-modal`        | `1.0.0-3`       | `1.x` -> `4.0`<br>`1.x`: standalone<br/>skip: `2.x`, `3.x`<br>`4.0`: peer dep to `rni-util` <br/>`5.0`: fabric/jsi |
| `rni-popover`      | `3.0.0`         | `3.x` -> `4.0` <br/>`5.0`: fabric/jsi                        |
| `rni-utilities`    | `3.0.0`         | `3.x` -> `4.0`<br>`4.0`: contains shared code from `rni-modal` + `rni-context-menu` <br/>`5.0`: fabric/jsi |





### Timeline

1. `react-native-ios-utilities` @ `3.x` -> `4.x`

	* Copy changes + shared code from `react-native-ios-modal`

	* Release `react-native-ios-modal` @ `4.x`
		* Peer dependency to `react-native-ios-utilities` @ `4.x`
		* Skip versions:  `2.x`, `3.x`.
		* Version `1.x` becomes the standalone version.
	* Release `react-native-ios-popover` @ `4.x`
		* Update to support the new version of `react-native-ios-utilities`
		* Update peer dependency.

2. `react-native-ios-utilities` @ `4.x` -> `5.x`









- [ ] `react-native-ios-context-menu` -> `react-native-ios-utilities`

	- [ ] `RNIImage`

		- [ ] `RNIImageGradientMaker`
		- [ ] `RNIImageItem`
		- [ ] `RNIImageLoadingConfig`
		- [ ] `RNIImageMaker`
		- [ ] `RNIImageOptions`
		- [ ] `RNIImageRemoteURLMaker`
		- [ ] `RNIImageRequireMaker`
		- [ ] `RNIImageSystemMaker`
		- [ ] `RNIImageType`
		- [ ] `RNIRemoteURLImageLoadingConfig`

		<br>

	- [ ] `RNIMisc`

		- [ ] `RNICleanable`
		- [ ] `RNICleanupMode`
		- [ ] `RNIJSComponentWillUnmountNotifiable`

		<br>

	- [ ] `RNINavigationEventsReporting`

		- [ ] `RNINavigationEventsNotifiable`
		- [ ] `RNINavigationEventsReportingViewController`

		<br>

	- [ ] `RNIUtilities`

		- [ ] `RNIUtilities`
		- [ ] `RNIUtilitiesModule`
		- [ ] `RNIUtilitiesModule`

		<br>

	- [ ] `RNIWrapperView`

		- [ ] `RNIWrapperView`
		- [ ] `RNIWrapperViewEventsNotifiable`
		- [ ] `RNIWrapperViewManager`
		- [ ] `RNIWrapperViewManager`
		- [ ] `RNIWrapperViewModule`
		- [ ] `RNIWrapperViewModule`

		<br>

	- [ ] `Extensions`

		- [ ] `Encodable+Helpers`
		- [ ] `UIColor+Helpers`

		<br>

	- [ ] `Extensions+Init`

	