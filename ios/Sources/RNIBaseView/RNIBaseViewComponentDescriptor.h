//
//  RNIBaseViewComponentDescriptor.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#if __cplusplus
#pragma once

#include "RNIBaseViewState.h"

#include <react/debug/react_native_assert.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/core/ConcreteState.h>
#include <react/renderer/components/view/ConcreteViewShadowNode.h>

#include <iostream>

namespace facebook::react {

template <typename ShadowNodeT>
class RNIBaseViewComponentDescriptor
  : public ConcreteComponentDescriptor<ShadowNodeT> {
  
public:
  using ConcreteComponentDescriptor<ShadowNodeT>::ConcreteComponentDescriptor;
  
  virtual void adopt(ShadowNode& shadowNode) const override {
    react_native_assert(
      dynamic_cast<YogaLayoutableShadowNode*>(&shadowNode)
    );
        
    auto& layoutableShadowNode =
      dynamic_cast<YogaLayoutableShadowNode&>(shadowNode);
      
    auto rawState = shadowNode.getState();

    auto state = std::dynamic_pointer_cast<
      const ConcreteState<RNIBaseViewState>
    >(rawState);
     
    if(state == nullptr){
      ConcreteComponentDescriptor<ShadowNodeT>::adopt(shadowNode);
      return;
    };
    
    RNIBaseViewState stateData = state->getData();
    LayoutMetrics layoutMetrics = layoutableShadowNode.getLayoutMetrics();
    
    Size newSize = stateData.frameSize;
    Size oldSize = layoutMetrics.frame.size;
    
    // NOTE: `Size` impl. custom `!=` op overload for checking inequality
    bool didChangeSize = newSize != oldSize;
    
    if (didChangeSize && stateData.shouldSetSize) {
      layoutableShadowNode.setSize(newSize);
    };
    
    if(stateData.shouldSetPadding){
      layoutableShadowNode.setPadding(stateData.padding);
    };
    
    if(stateData.shouldSetPositionType){
      layoutableShadowNode.setPositionType(stateData.positionType);
    };
    
    std::cout << "RNIBaseViewComponentDescriptor.adopt" << std::endl;
    std::cout << " - layoutableShadowNode.getTag: " << layoutableShadowNode.getTag() << std::endl;
    std::cout << " - layoutableShadowNode.getSurfaceId: " << layoutableShadowNode.getSurfaceId() << std::endl;
    std::cout << " - layoutableShadowNode.getOrderIndex: " << layoutableShadowNode.getOrderIndex() << std::endl;
    std::cout << " - layoutableShadowNode.getComponentName: " << layoutableShadowNode.getComponentName() << std::endl;
    std::cout << " - layoutableShadowNode.getComponentHandle: " << layoutableShadowNode.getComponentHandle() << std::endl;
    
    std::cout << "\n" << std::endl;
    
    //layoutableShadowNode.setPositionType(YGPositionType::1);
    
    // layoutableShadowNode.hasBeenMounted_;
    // layoutableShadowNode.getContentBounds();
    //layoutableShadowNode.
        
    ConcreteComponentDescriptor<ShadowNodeT>::adopt(shadowNode);
  }
};

} // facebook::react
#endif
