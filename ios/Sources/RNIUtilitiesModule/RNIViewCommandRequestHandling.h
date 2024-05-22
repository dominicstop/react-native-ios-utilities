//
//  RNIViewCommandRequestHandling.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/22/24.
//

#import <Foundation/Foundation.h>
#import "RNIUtilitiesModule.h"

@protocol RNIViewCommandRequestHandling <NSObject>

- (void)handleViewRequestWithArguments:(NSDictionary *)commandArguments
                               resolve:(RNIPromiseResolveBlock)resolveBlock
                                reject:(RNIPromiseRejectBlock)rejectBlock;

@end
