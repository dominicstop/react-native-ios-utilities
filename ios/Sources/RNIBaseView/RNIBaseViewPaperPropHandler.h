//
//  RNIBaseViewPaperPropHandler.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/23/24.
//

#import <Foundation/Foundation.h>

@class RNIBaseView;

@interface RNIBaseViewPaperPropHandler : NSObject

@property (nonatomic, weak, nullable) RNIBaseView *parentView;

- (nonnull instancetype)initWithParentRef:(nonnull RNIBaseView *)parentView;

- (void)setPropTypeMap:(nonnull NSDictionary *)propTypeMap;

@end
