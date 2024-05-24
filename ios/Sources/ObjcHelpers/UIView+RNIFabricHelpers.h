//
//  UIView+RNIFabricHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/9/24.
//

#import <UIKit/UIKit.h>

#if RCT_NEW_ARCH_ENABLED
@class RCTSurfaceHostingView;
@class RCTFabricSurface;
@class RNILayoutMetrics;
#endif

#if __cplusplus && RCT_NEW_ARCH_ENABLED
namespace facebook::react {
  class SurfaceHandler;
  struct LayoutMetrics;
}
#endif

@interface UIView (RNIFabricHelpers)

#if __cplusplus && RCT_NEW_ARCH_ENABLED
- (nullable RCTSurfaceHostingView *)reactGetClosestParentSurfaceHostingView;

- (nullable RCTFabricSurface *)reactGetClosestFabricSurface;

- (nullable facebook::react::SurfaceHandler *)reactGetSurfaceHandler;

- (nullable facebook::react::LayoutMetrics *)reactGetFabricLayoutMetrics;
#endif

// MARK: Visible To Swift
// ----------------------

#if RCT_NEW_ARCH_ENABLED
@property (nullable, readonly, nonatomic) RNILayoutMetrics *reactLayoutMetrics;
#endif

@end

