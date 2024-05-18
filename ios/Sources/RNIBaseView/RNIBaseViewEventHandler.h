//
//  RNIBaseViewEventHandler.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#import <Foundation/Foundation.h>

@class RNIBaseView;

@interface RNIBaseViewEventHandler : NSObject

@property (nonatomic, weak, nullable) RNIBaseView *parentView;

+ (nonnull NSMutableDictionary *)sharedClassRegistry;

- (nonnull instancetype)initWithParentRef:(nonnull id)ref;

- (void)invokeEventBlockForEventName:(nonnull NSString *)eventName
                         withPayload:(nonnull NSDictionary *)eventPayload;

@end
