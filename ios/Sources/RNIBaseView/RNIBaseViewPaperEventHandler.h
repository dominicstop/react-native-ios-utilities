//
//  RNIBaseViewPaperEventHandler.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/19/24.
//

#if !RCT_NEW_ARCH_ENABLED
#import <Foundation/Foundation.h>

@class RNIBaseView;

@interface RNIBaseViewPaperEventHandler : NSObject

// MARK: - Static/Class Members
// ----------------------------

+ (nonnull NSMutableDictionary *)sharedClassRegistry;
+ (nonnull NSMutableDictionary *)sharedSupportedEventRegistry;

// MARK: - Properties
// ------------------

@property (nonatomic, weak, nullable) RNIBaseView *parentView;

// MARK: - Methods
// ---------------

- (nonnull instancetype)initWithParentRef:(nonnull id)ref;

- (void)createSettersIfNeededForEvents:(nonnull NSArray *)events;

- (void)invokeEventBlockForEventName:(nonnull NSString *)eventName
                         withPayload:(nonnull NSDictionary *)eventPayload;

@end
#endif
