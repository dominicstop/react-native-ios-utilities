//
//  RNIWrapperViewShadowNode.h
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

#if __cplusplus
#pragma once

#include "RNIBaseViewShadowNode.h"

#include <react/renderer/components/RNIUtilitiesSpec/EventEmitters.h>
#include <react/renderer/components/RNIUtilitiesSpec/Props.h>

#include <react/renderer/components/view/ConcreteViewShadowNode.h>
#include <jsi/jsi.h>


namespace facebook::react {

JSI_EXPORT extern const char RNIWrapperViewComponentName[] = "RNIWrapperView";

class JSI_EXPORT RNIWrapperViewShadowNode final :
  public RNIBaseViewShadowNode<RNIWrapperViewComponentName> {

public:
  using RNIBaseViewShadowNode::RNIBaseViewShadowNode;
  
  static RNIBaseViewState initialStateData(
      const Props::Shared&r          , // props
      const ShadowNodeFamily::Shared&, // family
      const ComponentDescriptor&       // componentDescriptor
  ) {
    return {};
  }
};

} // facebook::react
#endif
