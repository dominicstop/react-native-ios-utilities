#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import "RCTBridge.h"
#import "Utils.h"

#import "react_native_ios_utilities-Swift.h"

@interface IosUtilitiesViewManager : RCTViewManager
@end

@implementation IosUtilitiesViewManager

RCT_EXPORT_MODULE(IosUtilitiesView)

- (UIView *)view
{
  
  UIView *view = [UIView new];
  
  NSNumber *result = @([TestClass addWithA:10 b:20]);
  
  UILabel *label = [UILabel new];
  label.text = [result.stringValue stringByAppendingString:@" Hello World, New Arch "];
  label.textColor = [UIColor blackColor];
  label.textAlignment = NSTextAlignmentCenter;
  
  label.translatesAutoresizingMaskIntoConstraints = NO;
  [view addSubview:label];

  NSArray *constraints = @[
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:label
                                 attribute:NSLayoutAttributeCenterX
                                multiplier:1.0
                                  constant:0.0],
                                  
    [NSLayoutConstraint constraintWithItem:label
                                 attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:label
                                 attribute:NSLayoutAttributeCenterY
                                multiplier:1.0
                                  constant:0.0],
  ];
  
  [NSLayoutConstraint activateConstraints:constraints];
  return view;
}

RCT_CUSTOM_VIEW_PROPERTY(color, NSString, UIView)
{
  [view setBackgroundColor: [Utils hexStringToColor:json]];
}

@end
