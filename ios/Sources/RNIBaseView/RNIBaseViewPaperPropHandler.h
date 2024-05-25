//
//  RNIBaseViewPaperPropHandler.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/23/24.
//

#import <Foundation/Foundation.h>

@class RNIBaseViewPaperPropHolder;
@class RNIBaseView;

@interface RNIBaseViewPaperPropHandler : NSObject

@property (nonatomic, weak, nullable) RNIBaseView *parentView;

@property (nonatomic, strong, nonnull) RNIBaseViewPaperPropHolder *propHolder;

- (nonnull instancetype)initWithParentRef:(nonnull RNIBaseView *)parentView;

- (void)createSettersForProps:(nonnull NSArray *)props;

- (void)setPropTypeMap:(nonnull NSDictionary *)propTypeMap;

@end