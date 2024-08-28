//
//  RNIBaseViewManager.m
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/28/24.
//

#import "RNIBaseViewManager.h"

#import "react-native-ios-utilities/Swift.h"
#import "react-native-ios-utilities/RNIBaseViewUtils.h"


@implementation RNIBaseViewManager

RNI_EXPORT_VIEW_EVENT(onDidSetViewID, RCTBubblingEventBlock)
RNI_EXPORT_VIEW_EVENT(onViewWillRecycle, RCTBubblingEventBlock)

@end
