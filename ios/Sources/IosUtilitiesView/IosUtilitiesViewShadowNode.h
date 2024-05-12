//
//  IosUtilitiesViewShadowNode.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/6/24.
//
#if __cplusplus
#pragma once

#include <react-native-ios-utilities/RNIBaseViewShadowNode.h>
#include <react-native-ios-utilities/RNIBaseViewProps.h>

#include <react/renderer/components/RNIosUtilitiesViewSpec/EventEmitters.h>
#include <react/renderer/components/RNIosUtilitiesViewSpec/Props.h>

#include <react/renderer/components/view/ConcreteViewShadowNode.h>
#include <jsi/jsi.h>


namespace facebook::react {

JSI_EXPORT extern const char IosUtilitiesViewComponentName[] = "IosUtilitiesView";

class JSI_EXPORT IosUtilitiesViewShadowNode final : public RNIBaseViewShadowNode<
  IosUtilitiesViewComponentName,
  RNIBaseViewProps,
  IosUtilitiesViewEventEmitter
> {

public:
  using RNIBaseViewShadowNode::RNIBaseViewShadowNode;
  
  static RNIBaseViewState initialStateData(
      const Props::Shared& /*props*/,
      const ShadowNodeFamily::Shared& /*family*/,
      const ComponentDescriptor& /*componentDescriptor*/
  ) {
    return {};
  }
};

} // facebook::react
#endif
