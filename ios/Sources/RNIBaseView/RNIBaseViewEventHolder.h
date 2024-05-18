//
//  RNIBaseViewEventHolder.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#import <Foundation/Foundation.h>

@class RNIBaseViewEventHandler;

@interface RNIBaseViewEventHolder : NSObject

@property (nonatomic, strong, nonnull) NSMutableDictionary *eventMap;

- (nonnull instancetype)initWithParentEventHandler:(nonnull RNIBaseViewEventHandler *)eventHandler;

- (void)registerEventEmitterForSelector:(nonnull SEL)selector
                       withEventEmitter:(nonnull id)eventEmitter;

@end
