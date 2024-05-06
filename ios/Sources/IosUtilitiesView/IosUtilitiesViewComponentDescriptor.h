//
//  IosUtilitiesViewComponentDescriptor.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/5/24.
//
#pragma once

#include "IosUtilitiesViewShadowNode.h"

#include <react/debug/react_native_assert.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>


namespace facebook {
namespace react {

class IosUtilitiesViewComponentDescriptor final
  : public ConcreteComponentDescriptor<IosUtilitiesViewShadowNode> {
  
  public:
    using ConcreteComponentDescriptor::ConcreteComponentDescriptor;

  void adopt(ShadowNode& shadowNode) const override {
    react_native_assert(
      dynamic_cast<IosUtilitiesViewShadowNode*>(&shadowNode)
    );
    
    auto& viewShadowNode =
      static_cast<IosUtilitiesViewShadowNode&>(shadowNode);

    react_native_assert(
      dynamic_cast<YogaLayoutableShadowNode*>(&viewShadowNode)
    );
        
    auto& layoutableShadowNode =
      dynamic_cast<YogaLayoutableShadowNode&>(viewShadowNode);
      
    auto rawState = shadowNode.getState();

    // auto state = std::static_pointer_cast<
    //   const IosUtilitiesViewShadowNode::ConcreteState
    // >(rawState);
            
    // auto stateData = state->getData();

    // if (stateData.frameSize.width != 0 && stateData.frameSize.height != 0) {
    //   layoutableShadowNode.setSize(
    //       Size{stateData.frameSize.width, stateData.frameSize.height});
    // }

    // ConcreteComponentDescriptor::adopt(shadowNode);
  }
};

} // namespace react
} // namespace facebook
