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

#if DEBUG
#include <iostream>
#endif



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
  
  using ConcreteViewShadowNode::ConcreteViewShadowNode;
  
  static ShadowNodeTraits BaseTraits() {
    auto traits = ConcreteViewShadowNode::BaseTraits();
    
    // style is modified
    traits.set(ShadowNodeTraits::Trait::DirtyYogaNode);
    return traits;
  }
  
  // NOTE: impl. in subclass to customize initial state
  static RNIBaseViewState initialStateData(
      const Props::Shared& /*props*/,
      const ShadowNodeFamily::Shared& /*family*/,
      const ComponentDescriptor& /*componentDescriptor*/
  ) {
    return {};
  };
  
#if REACT_NATIVE_TARGET_VERSION <= 74
  virtual Point getContentOriginOffset() const override {
#else
  virtual Point getContentOriginOffset() const {
#endif
    auto stateData = this->getStateData();
    return stateData.contentOffset;
  }
  
  void applyLayoutFromStateIfNeeded() {
    ConcreteViewShadowNode::ensureUnsealed();
    
    auto rawState = this->getState();

    auto state = std::dynamic_pointer_cast<
      const ConcreteState<RNIBaseViewState>
    >(rawState);
     
    if(state == nullptr){
      return;
    };
    
    RNIBaseViewState stateData = state->getData();
    LayoutMetrics layoutMetrics = this->getLayoutMetrics();
    
    bool shouldUpdateState = false;
    RNIBaseViewState newStateData = RNIBaseViewState(stateData);
    
    if (stateData.shouldSetSize) {
      Size newSize = stateData.frameSize;
      Size oldSize = layoutMetrics.frame.size;
      
      // NOTE: `Size` impl. custom `!=` op overload for checking inequality
      bool didChangeSize = newSize != oldSize;
      
      if(didChangeSize){
        this->setSize(newSize);
      };
    };
    
    if(stateData.shouldSetPadding){
      this->setPadding(stateData.padding);
    };
    
    if(stateData.shouldSetPositionType){
      this->setPositionType(stateData.positionType);
    };
    
    if(shouldUpdateState){
      state->updateState(std::move(newStateData));
    };
    
    yoga::Node &yogaNode = this->yogaNode_;
    yoga::Style &yogaStyle = yogaNode.style();
    
    bool doesNeedLayout = false;
    
    if(stateData.shouldSetMinWidth) {
      doesNeedLayout = true;


/// PR: #11, #20 (by: fobos531)
/// * https://github.com/dominicstop/react-native-ios-utilities/pull/20
/// * https://github.com/dominicstop/react-native-ios-utilities/pull/18
///
#if REACT_NATIVE_TARGET_VERSION >= 78
      yogaStyle.setMinDimension(
        yoga::Dimension::Width,
        yoga::StyleSizeLength::points(stateData.minSize.width)
      );
#elif REACT_NATIVE_TARGET_VERSION >= 77
      yogaStyle.setMinDimension(
        yoga::Dimension::Width,
        yoga::StyleLength::points(stateData.minSize.width)
      );
#else
      yogaStyle.setMinDimension(
        yoga::Dimension::Width,
        yoga::value::points(stateData.minSize.width)
      );
#endif
    };
    
    if(stateData.shouldSetMinHeight) {
      doesNeedLayout = true;

#if REACT_NATIVE_TARGET_VERSION >= 78
      yogaStyle.setMinDimension(
        yoga::Dimension::Height,
        yoga::StyleSizeLength::points(stateData.minSize.height)
      );
#elif REACT_NATIVE_TARGET_VERSION >= 77
      yogaStyle.setMinDimension(
        yoga::Dimension::Height,
        yoga::StyleLength::points(stateData.minSize.height)
      );
#else
      yogaStyle.setMinDimension(
        yoga::Dimension::Height,
        yoga::value::points(stateData.minSize.height)
      );
#endif
    };
    
    if(stateData.shouldSetMaxWidth) {
      doesNeedLayout = true;
    
#if REACT_NATIVE_TARGET_VERSION >= 78
      yogaStyle.setMinDimension(
        yoga::Dimension::Width,
        yoga::StyleSizeLength::points(stateData.maxSize.width)
      );
#elif REACT_NATIVE_TARGET_VERSION >= 77
      yogaStyle.setMinDimension(
        yoga::Dimension::Width,
        yoga::StyleLength::points(stateData.maxSize.width)
      );
#else
      yogaStyle.setMinDimension(
        yoga::Dimension::Width,
        yoga::value::points(stateData.maxSize.width)
      );
#endif
    };
    
    if(stateData.shouldSetMaxHeight) {
      doesNeedLayout = true;
#if REACT_NATIVE_TARGET_VERSION >= 78
      yogaStyle.setMinDimension(
        yoga::Dimension::Height,
        yoga::StyleSizeLength::points(stateData.maxSize.height)
      );
#elif REACT_NATIVE_TARGET_VERSION >= 77
      yogaStyle.setMinDimension(
        yoga::Dimension::Height,
        yoga::StyleLength::points(stateData.maxSize.height)
      );
#else
      yogaStyle.setMinDimension(
        yoga::Dimension::Height,
        yoga::value::points(stateData.maxSize.height)
      );
#endif
    };
    
    if(doesNeedLayout){
      yogaNode.setDirty(true);
    };
    
    #if DEBUG && FALSE
    Size newSize = stateData.frameSize;
    Size oldSize = layoutMetrics.frame.size;
    bool didChangeSize = newSize != oldSize;
    
    std::cout
      << "RNIBaseViewShadowNode::applyLayoutFromStateIfNeeded"
      << "\n - getComponentName: " << this->getComponentName()
      << "\n - getComponentHandle: " << this->getComponentHandle()
      << "\n - getTag: " << this->getTag()
      << "\n - getSurfaceId: " << this->getSurfaceId()
      << "\n - oldSize: " << oldSize.width << ", " << oldSize.height
      << "\n - newSize: " << newSize.width << ", " << newSize.height
      << "\n - didChangeSize: " << didChangeSize
      << "\n - doesNeedLayout:" << doesNeedLayout
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
      << "\n - state, minSize: " << stateData.minSize.width << ", " << stateData.minSize.height
      << "\n - state, shouldSetMinHeight: " << stateData.shouldSetMinHeight
      << "\n - state, shouldSetMinWidth: " << stateData.shouldSetMinWidth
      << "\n - state, maxSize: " << stateData.maxSize.width << ", " << stateData.maxSize.height
      << "\n - state, shouldSetMaxWidth: " << stateData.shouldSetMaxWidth
      << "\n - state, shouldSetMaxHeight: " << stateData.shouldSetMaxHeight
      << "\n - state, shouldSetMaxHeight: " << stateData.shouldSetMaxHeight
      << "\n - style, minHeight: " << yogaStyle.minDimension(yoga::Dimension::Height).value().unwrap()
      << "\n - style, maxHeight: " << yogaStyle.maxDimension(yoga::Dimension::Height).value().unwrap()
      << "\n - style, minWidth: " << yogaStyle.minDimension(yoga::Dimension::Width).value().unwrap()
      << "\n - style, maxWidth: " << yogaStyle.maxDimension(yoga::Dimension::Width).value().unwrap()
      << "\n"
      << std::endl;
    #endif
  }
};

} // facebook::react
#endif

