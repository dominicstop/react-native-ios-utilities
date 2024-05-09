//
//  UIView+RNIFabricHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/9/24.
//

#import <UIKit/UIKit.h>


@class RCTSurfaceHostingView;
@class RCTFabricSurface;

#if __cplusplus
namespace facebook::react {
  class SurfaceHandler;
}
#endif

@interface UIView (RNIFabricHelpers)

#if __cplusplus
- (nullable RCTSurfaceHostingView *)reactGetClosestParentSurfaceHostingView;

- (nullable RCTFabricSurface *)reactGetClosestFabricSurface;

- (nullable facebook::react::SurfaceHandler *)reactGetSurfaceHandler;
#endif

@end

