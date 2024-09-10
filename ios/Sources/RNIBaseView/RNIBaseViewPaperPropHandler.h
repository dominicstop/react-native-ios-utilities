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

// MARK: - Static/Class Members
// ----------------------------

+ (nonnull NSMutableDictionary *)sharedClassRegistry;
+ (nonnull NSMutableDictionary *)sharedSupportedPropsRegistry;

// MARK: - Properties
// ------------------

@property (nonatomic, weak, nullable) RNIBaseView *parentView;

@property (nonatomic, strong, nonnull) RNIBaseViewPaperPropHolder *propHolder;

// MARK: - Methods
// ---------------

- (nonnull instancetype)initWithParentRef:(nonnull RNIBaseView *)parentView;

- (void)createSettersIfNeededForProps:(nonnull NSArray *)props;

- (void)setPropTypeMapIfNeeded:(nonnull NSDictionary *)propTypeMap;

@end
