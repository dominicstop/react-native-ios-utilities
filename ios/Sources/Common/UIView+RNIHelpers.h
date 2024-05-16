//
//  UIView+RNIHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <UIKit/UIKit.h>

@class RCTBridge;
@class RNILayoutMetrics;

typedef BOOL (^ RNIResponderPredicateBlock)(UIResponder * _Nonnull);

@interface UIView (RNIHelpers)

- (nullable UIResponder *)findParentResponderForPredicate:(nonnull RNIResponderPredicateBlock)predicateBlock;

- (nonnull NSArray<UIView*> *)recursivelyGetAllSubviews;

// MARK: - React-Native Related
// ----------------------------

- (nullable RCTBridge *)reactGetPaperBridge;

- (nullable NSString *)reactGetNativeID;

- (nullable RNILayoutMetrics *)reactGetLayoutMetrics;

@end
