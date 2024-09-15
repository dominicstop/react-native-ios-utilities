//
//  RNIBaseViewComponentDescriptor.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#if __cplusplus
#pragma once

#include "RNIBaseViewState.h"
#include "RNIBaseViewShadowNode.h"
#include "RNIBaseViewEventEmitter.h"

#include <react/debug/react_native_assert.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/core/ConcreteState.h>
#include <react/renderer/components/view/ConcreteViewShadowNode.h>


namespace facebook::react {

template <
  typename ShadowNodeT,
  const char* concreteComponentName
>
class RNIBaseViewComponentDescriptor
  : public ConcreteComponentDescriptor<ShadowNodeT> {
  
public:
  using ConcreteComponentDescriptor<ShadowNodeT>::ConcreteComponentDescriptor;
  
  virtual void adopt(ShadowNode& shadowNode) const override {
    react_native_assert(
      dynamic_cast<YogaLayoutableShadowNode*>(&shadowNode)
    );
    
    auto &baseViewShadowNode = static_cast<
      RNIBaseViewShadowNode<concreteComponentName>&
    >(shadowNode);
    
    baseViewShadowNode.applyLayoutFromStateIfNeeded();
    ConcreteComponentDescriptor<ShadowNodeT>::adopt(shadowNode);
  }
};

} // facebook::react
#endif
