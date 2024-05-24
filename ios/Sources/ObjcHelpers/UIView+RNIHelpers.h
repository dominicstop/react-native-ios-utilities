//
//  UIView+RNIHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <UIKit/UIKit.h>

@class RNILayoutMetrics;

typedef BOOL (^RNIResponderPredicateBlock)(UIResponder * _Nonnull);
typedef BOOL (^RNIViewPredicateBlock)(UIView * _Nonnull);
typedef void (^RNILayoutMetricsCompletionBlock)(RNILayoutMetrics * _Nullable);

@interface UIView (RNIHelpers)

- (nullable UIResponder *)findParentResponderForPredicate:(nonnull RNIResponderPredicateBlock)predicateBlock;

- (nullable UIView *)recursivelyFindSubviewForPredicate:(nonnull RNIViewPredicateBlock)predicateBlock;

- (nonnull NSArray<UIView*> *)recursivelyGetAllSubviews;

// MARK: - React-Native Related
// ----------------------------

@property (nullable, readonly, nonatomic) NSString *reactNativeID;

@property (nullable, readonly, nonatomic) NSNumber *reactNativeTag;

- (void)reactGetLayoutMetricsWithCompletionHandler:(nonnull RNILayoutMetricsCompletionBlock)completionBlock;

@end
