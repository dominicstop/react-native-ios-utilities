# TODO - `react-native-ios-utilities`

💖🌼

<br><br>

## TODO - Current Tasks

- [ ] `TODO:2023-10-05-17-01-58` - Impl: `RNIDummyView` - Impl, `RNIDummyViewRegistryManager`.
- [ ] `TODO:2023-10-05-17-00-32` - Impl: `RNIDummyView` Prop - Impl. `shouldAutoDetachFromSuperview`. 

<br><br>

## Version `next`

- [x]  `TODO:2023-10-05-12-46-37` - Impl: `RNIDummyView` - Impl. `shouldCleanupOnComponentWillUnmount` prop.
- [x] `TODO:2023-10-05-12-33-20` - Impl: Rewrite `RNIWrapperView` - Initial impl. for `RNIDummyView`,
- [x] `TODO:2023-10-05-12-30-30` - Impl: Re-add prev. deleted sources, and update/re-write them.
- [x] `TODO:2023-10-05-12-25-42` - Refactor: Delete all sources and related-files, and init. repository w/ expo modules.

<br><br>

## Version ``0.0.3`

- [x]  (Commit: `55e9c59`) **Fix**: Make Initializers Public

<br><br>

## Version ``0.0.2`

- [x] (Commit: `d5fcf6d`) **Fix**: Move `RNIError` To Correct Directory
	* Move `RNIError` folder from project root to `/ios/Src`

<br><br>

## Version `0.0.1`

- [x]  (Commit: `6aaa909`) **Implement**: Import native code from `react-native-ios-popover`
	- [x] **Implement**: Update/refactor imported code from `react-native-ios-popover`.
		- [x] (Commit: `331bc37`) **Implement**: Refactor: `RNIError` 
			* Move `RNIError` to own folder, and extract `RNIGenericError` to its own file.
		- [x] (Commit: `2e247aa`) **Implement**: `RNIGenericError`
			* Re-implementation of `RNIPopoverError` to fix build errors.
		- [x] (Commit: `4a57264`) **Refactor**: Replace Usage w/ `RNIGenericError` 
			* Refactor to replace imported code from `react-native-ios-popover` to use `RNIGenericError` instead of `RNIPopoverError`
		- [x] (Commit: `9fea397`) **Refactor**: Make Classes/Protocols Public

<br><br>

## TODO - Archived

- [ ] Migrate `react-native-ios-context-menu` to use `react-native-ios-utilities`
  - [x] (Commit: `d40eb75`) Add: Import From `react-native-ios-context-menu`
  - [x] (Commit: `e0791be`) Refactor: Make Classes/Protocols Public
    * Refactor imported code from `react-native-ios-context-menu` to be public (i.e. accessible outside of the module).
  - [x] (Commit: `7debefe`) Refactor: Extract To Separate Files
    * Extract structs/classes from `RNIImage/RNIImageItem` to their own separate files.

<br>

- [ ] **Task**: Set initial version number for library.
  * E.g. If `react-native-ios-utilities` starts with version `2.x`, then all other libraries that use must also start with `2.x`.
    * Figure out shared major version between all libraries, i.e. among the other libraries, find the one that has the highest version number, then use that as the initial version number for this library.
      * **Major**: An increment in the major version means that it will break compatibility in some way via "public facing" changes to the API, e.g. renaming public identifiers, changing required protocol conformances, major refactors, renaming files, changing the project structure, etc.
      * **Minor**: An increment in the minor version means that there are significant, but not major, changes to internal code — it is safe to upgrade because it doesn't have any breaking changes to the public API.
      * **Patch**: An increment in the patch version is for fixing minor bugs or superficial changes, i.e. it is safe for "automatic upgrades".

<br>

- [ ] Migrate `react-native-ios-navigator` to use `react-native-ios-utilities`

<br>

- [ ] `TODO:2023-04-22-23-22-57` - Impl. object that describes how the "native component" should be laid out.

  * **Desc**: E.g. a "layout  configuration" object that support for values that are either relative (percent), or constant, and it will also have offsets to add to the initial calculation, etc. 

    * The  "layout  configuration" object will be parsed and evaluated in native, and will be used for basic "layout calculations" that are outside of "yoga layout"'s control.

      * It's always better to just manipulate either JS styles, or it's corresponding shadow view.
      * But if the target view is not a "react view", this is not possible.

    * This "layout configuration object" will be used for calculating the size, position, center, etc.

      * For example, the size could be some percentage of the parent width or some constant height.
      * The "layout configuration object" will basically spit out a `CGRect`, and `CGSize`.

    * With JSI/Fabric, it might also be possible to accept a JS function that gets called whenever the computation is needed. The JS function will receive a "layout environment" object as an argument, and it must return some value.

      * The "layout environment" will contain the size/position of the parent view, the size of the window, along with other arguments.
      * E.g. like other related-views, like an array of sibling views, or the "view hierarchy" represented as an nested object.
      * Alongside the layout-related metadata of the views, they will also have other properties like a "user defined ID", it's `reactTag`, the "current window ID", it's "associated view-controller" + metadata regarding the  view controller, etc).
      * Though, this might be too expensive for recurring layout calculations, but can be supported on any platform.

    * It might also be possible to represent "`UIKkit` autolayout" as an object.

      * E.g. the "autolayout configuration" object will be evaluated, and will return an array of constraints to activate. 
      * In order to construct the "autolayout configuration" object, it will also receive an "layout environment object".

    * A more outrageous/impractical solution is to make a recursive parser for evaluating "layout calculations" (similar to the old version of `react-native-reanimated`, but in object/json format 🤣).

      * E.g. `[100, "+", {mode: 'layout', value: 'height', target: 'parent'}]`

        * ```json
          [[
            0.6, '*', {
              mode: 'layout_value',
              valueFor: 'width',
              target: {
                type: 'subview',
                target: 'parent',
                subviewIndex: 2,
              }
            }], '+', 300
          ]
          ```

        * ```json
          [{
          	mode: 'set_variable',
          	key: 'parent_half_height',
            value: [
            	0.5, '*', {
                mode: 'layout_value',
                valueFor: 'height',
                target: 'parent',
              },
            ],
          }, [
            100, '+', {
          	mode: 'get_variable',
          	key: 'parent_half_height'
          }], {
          	mode: 'combine_with_previous',
            rhs: [
            	'+', 100
            ]
          }]
          ```

        * ```json
          
          ```

      * This is severely impractical and complicated due to it being very verbose.

        * Not to mention, how would you even begin to debug this? How is branching handled?
          * This will become very unreadable and unmaintainable vert fast.
        * Another caveat is code-reuse. Even if there was a mechanism to create functions, how would you re-use it across different layout computations.
        * This is basically making a Turing complete DSL but in JSON. 
          * The symbols in arrays are sequentially evaluated. 
        * But it is possible to implement, it's just very cursed 🤣
        * It's only advantage is that you don't need to run javascript on the main thread because it can just be evaluated immediately.



