//
//  RNIViewRegistry.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/22/24.
//

#import <UIKit/UIKit.h>

@protocol RNIRegistrableView;

@interface RNIViewRegistry : NSObject

+ (nonnull instancetype)shared;

- (void)registerView:(UIView<RNIRegistrableView> * _Nonnull)view;

- (nullable UIView *)getViewForViewID:(NSString * _Nonnull)viewID;

@end
