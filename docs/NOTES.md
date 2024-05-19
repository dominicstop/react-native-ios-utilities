# NOTES - `react-native-ios-utilities`

<br><br>

* Expos methods/properties from react to swift:
  * Expose fabric methods to swift: `handleCommand`, `updateEventEmitter`.
  * Expose paper methods to swift: `didUpdateReactSubviews`
  * Expose in Fabric via ivar: `NSMutableArray<UIView *> *_reactSubviews;`
  * Expose methods to add + remove items in `_reactSubviews`/`reactSubviews`.
  * Bridge `tag` (fabric), and `reactTag`(paper) into a common property for swift.

<br><br>

* Observation: `RCTViewComponentView`
  * Defines the ff. ivar's: `_layoutMetrics`, `_props`, `_eventEmitter` ([link to interface definition](https://github.com/facebook/react-native/blob/13dff7cdf2635cb39f70effe3dc1ae2f3dd0131f/packages/react-native/React/Fabric/Mounting/ComponentViews/View/RCTViewComponentView.h#L25-L30)).<br><br>

* Observations: `UIView.tag`
  * On fabric, the exported view (`RCTViewComponentView`) has a tag set.
  * On fabric, the `childComponentView` (in `mountChildComponentView`, and `unmountChildComponentView`) has a tag set.
  * On fabric, the swift content view delegate does not have a tag set.<br><br>

* Observation: `nativeID`
  * On fabric, the `nativeID` is a property in [Props.h](https://github.com/facebook/react-native/blob/d0bb396ddb0c738524099b034276e0c3fb031347/packages/react-native/ReactCommon/react/renderer/core/Props.h#L58), and can be read in native via the props event.
    * The `props` property is required in `ComponentViewProtocol`, but the default impl. does nothing, as such the implementor of  `ComponentViewProtocol` might not set the `props` property properly?
  * On fabric, `nativeID` is a property in `RCTViewComponentView` ([link to code snippet](https://github.com/facebook/react-native/blob/13dff7cdf2635cb39f70effe3dc1ae2f3dd0131f/packages/react-native/React/Fabric/Mounting/ComponentViews/View/RCTViewComponentView.h#L49)).

<br>

* Expose "view commands" to fabric + paper.
  * Fabric - 

