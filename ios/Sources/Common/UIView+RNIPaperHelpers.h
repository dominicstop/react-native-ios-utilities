//
//  UIView+RNIPaperHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/17/24.
//

#import <UIKit/UIKit.h>
#import <React/RCTLayout.h>

@class RCTBridge;
@class RCTRootView;

typedef void (^RNIPaperLayoutMetricsCompletionBlock)(RCTLayoutMetrics layoutMetrics, BOOL isSuccessful);
typedef void (^RNIPaperShadowViewCompletionBlock)(RCTShadowView * _Nullable shadowView);

@interface UIView (RNIPaperHelpers)

- (nonnull RCTBridge *)reactGetPaperBridge;

- (nullable RCTRootView *)reactGetPaperRootView;

- (void)reactGetPaperLayoutMetricsWithCompletionHandler:(nonnull RNIPaperLayoutMetricsCompletionBlock)completionBlock;

- (void)reactGetShadowViewWithCompletionHandler:(nonnull RNIPaperShadowViewCompletionBlock)completionBlock;

@end
