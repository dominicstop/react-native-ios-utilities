//
//  RNIDummyTestViewShadowNode.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//
#if __cplusplus
#pragma once

#include "RNIBaseViewShadowNode.h"
#include "RNIBaseViewProps.h"
#include "RNIBaseViewEventEmitter.h"

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
