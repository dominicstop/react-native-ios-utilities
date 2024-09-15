//
//  RNIBaseViewShadowNode.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#if __cplusplus
#pragma once

#include "RNIBaseViewProps.h"
#include "RNIBaseViewState.h"
#include "RNIBaseViewEventEmitter.h"

#include <react/renderer/components/RNIUtilitiesSpec/EventEmitters.h>
#include <react/renderer/components/RNIUtilitiesSpec/Props.h>

#include <react/renderer/components/view/ConcreteViewShadowNode.h>
#include <jsi/jsi.h>


namespace facebook::react {

template <
  const char* concreteComponentName,
  typename ViewPropsT = RNIBaseViewProps,
  typename ViewEventEmitterT = RNIBaseViewEventEmitter
>
class JSI_EXPORT RNIBaseViewShadowNode : public ConcreteViewShadowNode<
  concreteComponentName,
  ViewPropsT,
  ViewEventEmitterT,
  RNIBaseViewState
> {

public:

  using ConcreteViewShadowNode = ConcreteViewShadowNode<
    concreteComponentName,
    ViewPropsT,
    ViewEventEmitterT,
    RNIBaseViewState
  >;
  
#if REACT_NATIVE_TARGET_VERSION <= 74
  virtual Point getContentOriginOffset() const override {
#else
  virtual Point getContentOriginOffset() const {
#endif
    auto stateData = this->getStateData();
    return stateData.contentOffset;
  }
  
  // NOTE: impl. in subclass to customize initial state
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

