//
//  UIView+RNIHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <UIKit/UIKit.h>

@class RCTBridge;
@class RNILayoutMetrics;

typedef BOOL (^ ResponderPredicateBlock)(UIResponder * _Nonnull);

@interface UIView (RNIHelpers)

- (nullable UIResponder *)findParentResponderWhere:(nonnull ResponderPredicateBlock)predicateBlock;

- (nonnull NSArray<UIView*> *)recursivelyGetAllSubviews;

// MARK: - React-Native Related
// ----------------------------

- (nullable RCTBridge *)reactGetPaperBridge;

- (nullable NSString *)reactGetNativeID;

- (nullable RNILayoutMetrics *)reactGetLayoutMetrics;

@end
