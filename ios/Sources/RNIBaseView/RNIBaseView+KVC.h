#import "RNIBaseView.h"

NS_ASSUME_NONNULL_BEGIN


/// PR-#11 by: coolsoftwaretyler
/// Link: https://github.com/dominicstop/react-native-ios-utilities/pull/11
///
/// * When using new arch + dynamic linkage, the fabric views don't get
///   initialized
///
/// * The specs for the fabric views are defined in:
///   `RCTThirdPartyFabricComponentsProvider`
///
/// * When dynamic linkage is enabled, none of the specs defined are exported
///   due to `RCT_DYNAMIC_FRAMEWORKS` being set to false.
///
/// * Related issue:
///   https://github.com/software-mansion/react-native-screens/issues/2228
///
@interface RNIBaseView (KVC)

- (id)valueForUndefinedKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END 
