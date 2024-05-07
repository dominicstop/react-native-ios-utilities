//
//  RNIBaseViewComponentDescriptor.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#pragma once

#include "RNIBaseViewState.h"

#include <react/debug/react_native_assert.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>
#include <react/renderer/core/ConcreteState.h>
#include <react/renderer/components/view/ConcreteViewShadowNode.h>


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
    Size newSize = stateData.frameSize;
    
    LayoutMetrics layoutMetrics = layoutableShadowNode.getLayoutMetrics();
    Size oldSize = layoutMetrics.frame.size;
    
    // NOTE: `Size` impl. custom `!=` op overload for checking inequality
    bool didChangeSize = newSize != oldSize;
    bool isNewSizeValid = newSize.width != 0 && newSize.height != 0;

    if (didChangeSize && isNewSizeValid) {
      layoutableShadowNode.setSize(newSize);
    };

    ConcreteComponentDescriptor<ShadowNodeT>::adopt(shadowNode);
  }
};

} // facebook::react

