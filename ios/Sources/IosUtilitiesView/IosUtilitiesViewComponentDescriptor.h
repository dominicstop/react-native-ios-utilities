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

    auto state = std::static_pointer_cast<
       const IosUtilitiesViewShadowNode::ConcreteState
     >(rawState);
            
    IosUtilitiesViewState stateData = state->getData();
    Size newSize = stateData.frameSize;
    
    LayoutMetrics layoutMetrics = viewShadowNode.getLayoutMetrics();
    Size oldSize = layoutMetrics.frame.size;
    
    // NOTE: `Size` impl. custom `!=` op for checking inequality
    bool didChangeSize = newSize != oldSize;
    bool isNewSizeValid = newSize.width != 0 && newSize.height != 0;

    if (didChangeSize && isNewSizeValid) {
      layoutableShadowNode.setSize(newSize);
    };

    ConcreteComponentDescriptor::adopt(shadowNode);
  }
};

} // namespace react
} // namespace facebook
