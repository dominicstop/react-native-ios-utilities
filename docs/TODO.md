

# TODO (react-native-ios-utilities)



- [x]  (Commit: `6aaa909`) **Implement**: Import native code from `react-native-ios-popover`

	

	- [ ] **Implement**: Update/refactor imported code from `react-native-ios-popover`.

		- [x] (Commit: `331bc37`) **Implement**: Refactor: `RNIError` 

			* Move `RNIError` to own folder, and extract `RNIGenericError` to its own file.

			

		- [x] (Commit: `2e247aa`) **Implement**: `RNIGenericError`

			* Re-implementation of `RNIPopoverError` to fix build errors.

			

		- [ ] **Refactor**: Replace Usage w/ `RNIGenericError` 

			* Refactor to replace imported code from `react-native-ios-popover` to use `RNIGenericError` instead of `RNIPopoverError`

<br>

- [ ] **Task**: Set initial version number for library.
	* E.g. If `react-native-ios-utilities` starts with version `2.x`, then all other libraries that use must also start with `2.x`.
		* Figure out shared major version between all libraries, i.e. among the other libraries, find the one that has the highest version number, then use that as the initial version number for this library.
			* **Major**: An increment in the major version means that it will break compatibility in some way via "public facing" changes to the API, e.g. renaming public identifiers, changing required protocol conformances, major refactors, renaming files, changing the project structure, etc.
			* **Minor**: An increment in the minor version means that there are significant, but not major, changes to internal code — it is safe to upgrade because it doesn't have any breaking changes to the public API.
			* **Patch**: An increment in the patch version is for fixing minor bugs or superficial changes, i.e. it is safe for "automatic upgrades".



