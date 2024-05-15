//
//  UIView+RNIHelpers.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/8/24.
//

#import <UIKit/UIKit.h>


typedef BOOL (^ ResponderPredicateBlock)(UIResponder * _Nonnull);

@interface UIView (RNIHelpers)

- (nullable UIResponder *)findParentResponderWhere:(nonnull ResponderPredicateBlock)predicateBlock;

- (nullable NSString *)getReactNativeID;

@end
