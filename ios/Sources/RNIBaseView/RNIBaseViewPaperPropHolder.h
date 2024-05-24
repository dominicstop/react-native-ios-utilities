//
//  RNIBaseViewPaperPropHolder.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/23/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RNIBaseViewPaperPropHandler;

@interface RNIBaseViewPaperPropHolder : NSObject

@property(nonatomic, nonnull) NSDictionary *propsMap;

@property (nonatomic, weak, nullable) RNIBaseViewPaperPropHandler *parentPropHandler;

- (instancetype)initWithParentPropHandler:(RNIBaseViewPaperPropHandler *)propHandler;

- (void)handlePropSetterCallForSelector:(SEL)selector
                          withPropValue:(id)propValue;

@end

NS_ASSUME_NONNULL_END
