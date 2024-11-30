#import "RNIBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RNIBaseView (KVC)

- (id)valueForUndefinedKey:(NSString *)key;
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END 