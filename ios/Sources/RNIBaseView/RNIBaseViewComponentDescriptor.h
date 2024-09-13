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

#if DEBUG
#include <iostream>
#endif


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
    
#if DEBUG && FALSE
    std::cout
      << "RNIBaseViewComponentDescriptor.adopt"
      << "\n - getComponentName: " << layoutableShadowNode.getComponentName()
      << "\n - getComponentHandle: " << layoutableShadowNode.getComponentHandle()
      << "\n - getTag: " << layoutableShadowNode.getTag()
      << "\n - getSurfaceId: " << layoutableShadowNode.getSurfaceId()
      << "\n - oldSize: " << oldSize.width << ", " << oldSize.height
      << "\n - newSize: " << newSize.width << ", " << newSize.height
      << "\n - didChangeSize: " << didChangeSize
      << "\n - state, shouldSetSize: " << stateData.shouldSetSize
      << "\n - state, frameSize.height: " << stateData.frameSize.height
      << "\n - state, frameSize.width: " << stateData.frameSize.width
      << "\n - state, contentOffset.x: " << stateData.contentOffset.x
      << "\n - state, contentOffset.y: " << stateData.contentOffset.y
      << "\n - state, shouldSetPadding: " << stateData.shouldSetPadding
      << "\n - state, padding.top: " << stateData.padding.top
      << "\n - state, padding.bottom: " << stateData.padding.bottom
      << "\n - state, padding.left: " << stateData.padding.left
      << "\n - state, padding.right: " << stateData.padding.right
      << "\n - state, shouldSetPositionType: " << stateData.shouldSetPositionType
      << "\n - state, positionType: " << stateData.positionType
      << "\n"
      << std::endl;
#endif
    
    ConcreteComponentDescriptor<ShadowNodeT>::adopt(shadowNode);
  }
};

} // facebook::react
#endif
