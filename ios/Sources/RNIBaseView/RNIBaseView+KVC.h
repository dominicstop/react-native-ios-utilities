#import "RNIBaseView.h"

NS_ASSUME_NONNULL_BEGIN


/// PR-#11 by: coolsoftwaretyler
/// Link: https://github.com/dominicstop/react-native-ios-utilities/pull/11
///
/// * it seems that these properties are being invoked by fabric:
///   `reactEventHandler`, and `reactPropHandler` (these are not currently
///    impl. in `RNIBaseView`, and will cause a crash).
///
/// * these properties return a map of the props/events names and their
///   corresponding handler.
///
/// * the PR intercepts the calls for `reactEventHandler` and `reactPropHandler`
///   and returns dummy handlers for: `onDidSetViewID`, `onViewWillRecycle`,
///   `onRawNativeEvent`.
///
/// * currently, the props for fabric are only intercepted using the
///   `updateProps` lifecycle method; perhaps this is not enough by itself.
///
/// * the commit states: "fix: dynamic framework compatibility"; this could
///   be the reason why the breakpoints aren't being triggered.
///
/// * TODO: create a permanent fix
/// * read the prop map + event list from swift, and vend the
///   "props/events handlers map" for fabric.
///
@interface RNIBaseView (KVC)

- (id)valueForUndefinedKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END 
