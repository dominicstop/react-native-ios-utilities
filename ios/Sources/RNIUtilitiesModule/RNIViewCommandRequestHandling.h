//
//  RNIViewCommandRequestHandling.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/22/24.
//

#import <Foundation/Foundation.h>
#import "RNIUtilitiesModule.h"

NS_ASSUME_NONNULL_BEGIN
@protocol RNIViewCommandRequestHandling <NSObject>

- (void)handleViewRequestForCommandName:(NSString *)commandName
                          withArguments:(NSDictionary *)commandArguments
                                resolve:(RNIPromiseResolveBlock)resolveBlock
                                 reject:(RNIPromiseRejectBlock)rejectBlock NS_SWIFT_NAME(handleViewRequest(forCommand:withCommandArguments:resolve:reject:));

@end
NS_ASSUME_NONNULL_END
