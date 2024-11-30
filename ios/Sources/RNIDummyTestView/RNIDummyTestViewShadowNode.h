//
//  RNIDummyTestViewShadowNode.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//
#if __cplusplus
#pragma once

#if __has_include(<react_native_ios_utilities/RNIBaseViewShadowNode.h>)
#import <react_native_ios_utilities/RNIBaseViewShadowNode.h>
#import <react_native_ios_utilities/RNIBaseViewProps.h>
#import <react_native_ios_utilities/RNIBaseViewEventEmitter.h>
#else
#include <react-native-ios-utilities/RNIBaseViewShadowNode.h>
#include <react-native-ios-utilities/RNIBaseViewProps.h>
#include <react-native-ios-utilities/RNIBaseViewEventEmitter.h>
#endif


#include <react/renderer/components/RNIUtilitiesSpec/EventEmitters.h>
#include <react/renderer/components/RNIUtilitiesSpec/Props.h>

#include <react/renderer/components/view/ConcreteViewShadowNode.h>
#include <jsi/jsi.h>


namespace facebook::react {

JSI_EXPORT extern const char RNIDummyTestViewComponentName[] = "RNIDummyTestView";

class JSI_EXPORT RNIDummyTestViewShadowNode final :
  public RNIBaseViewShadowNode<RNIDummyTestViewComponentName> {

public:
  using RNIBaseViewShadowNode::RNIBaseViewShadowNode;
  
  static RNIBaseViewState initialStateData(
      const Props::Shared&r           , // props
      const ShadowNodeFamily::Shared&, // family
      const ComponentDescriptor&       // componentDescriptor
  ) {
    return {};
  }
};

} // facebook::react
#endif
