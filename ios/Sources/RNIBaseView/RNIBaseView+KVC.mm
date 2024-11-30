#import "RNIBaseView.h"

@implementation RNIBaseView (KVC)

- (id)valueForUndefinedKey:(NSString *)key
{
#if RCT_NEW_ARCH_ENABLED
  if ([key isEqualToString:@"reactEventHandler"]) {
    // Return a dummy event handler block for Fabric
    return @{
      @"onDidSetViewID": [^(id value) {} copy],
      @"onViewWillRecycle": [^(id value) {} copy],
      @"onRawNativeEvent": [^(id value) {} copy]
    };
  }
  
  if ([key isEqualToString:@"reactPropHandler"]) {
    // Return a dummy prop handler for Fabric
    return @{
      @"propName": [NSNull null]
    };
  }
#endif
  return [super valueForUndefinedKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
#if RCT_NEW_ARCH_ENABLED
  if ([key isEqualToString:@"reactEventHandler"] ||
      [key isEqualToString:@"reactPropHandler"]) {
    // No-op for Fabric
    return;
  }
#endif
  [super setValue:value forUndefinedKey:key];
}

@end