//
//  RNIBaseViewPaperEventHolder.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if !RCT_NEW_ARCH_ENABLED
#import <Foundation/Foundation.h>

@class RNIBaseViewPaperEventHandler;

@interface RNIBaseViewPaperEventHolder : NSObject

@property (nonatomic, strong, nonnull) NSMutableDictionary *eventMap;

- (nonnull instancetype)initWithParentEventHandler:(nonnull RNIBaseViewPaperEventHandler *)eventHandler;

- (void)registerEventEmitterForSelector:(nonnull SEL)selector
                       withEventEmitter:(nonnull id)eventEmitter;

@end
#endif
