//
//  UIView+RNIHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <UIKit/UIKit.h>
#import <React/RCTLayout.h>

@class RCTBridge;
@class RNILayoutMetrics;
@class RCTRootView;

typedef BOOL (^RNIResponderPredicateBlock)(UIResponder * _Nonnull);
typedef BOOL (^RNIViewPredicateBlock)(UIView * _Nonnull);
typedef void (^RNILayoutMetricsCompletionBlock)(RNILayoutMetrics * _Nullable);
typedef void (^RNIPaperLayoutMetricsCompletionBlock)(RCTLayoutMetrics layoutMetrics, BOOL isSuccessful);
typedef void (^RNIPaperShadowViewCompletionBlock)(RCTShadowView * _Nullable shadowView);


@interface UIView (RNIHelpers)

- (nullable UIResponder *)findParentResponderForPredicate:(nonnull RNIResponderPredicateBlock)predicateBlock;

- (nullable UIView *)recursivelyFindSubviewForPredicate:(nonnull RNIViewPredicateBlock)predicateBlock;

- (nonnull NSArray<UIView*> *)recursivelyGetAllSubviews;

// MARK: - React-Native Related
// ----------------------------

@property (nullable, readonly, nonatomic) NSString *reactNativeID;

- (void)reactGetLayoutMetricsWithCompletionHandler:(nonnull RNILayoutMetricsCompletionBlock)completionBlock;

// MARK: React-Native - Paper-Related
// ----------------------------------

- (nullable RCTBridge *)reactGetPaperBridge;

- (nullable RCTRootView *)reactGetPaperRootView;

- (void)reactGetPaperLayoutMetricsWithCompletionHandler:(nonnull RNIPaperLayoutMetricsCompletionBlock)completionBlock;

- (void)reactGetShadowViewWithCompletionHandler:(nonnull RNIPaperShadowViewCompletionBlock)completionBlock;

@end
