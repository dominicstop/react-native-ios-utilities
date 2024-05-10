//
//  RNIBaseViewState.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#if __cplusplus
#pragma once

#include <react/renderer/graphics/Float.h>
#include <react/renderer/graphics/Rect.h>
#include <react/renderer/graphics/RectangleEdges.h>
#include <react/renderer/core/graphicsConversions.h>

#include <react/renderer/core/ConcreteState.h>
#include <folly/dynamic.h>


namespace facebook::react {

class RNIBaseViewState {
public:
  
  using ConcreteState = ConcreteState<RNIBaseViewState>;
  using SharedConcreteState = std::shared_ptr<const ConcreteState>;
  
  // frameHeight
  // frameWidth
  Size frameSize;
  
  // contentOffsetX
  // contentOffsetY
  Point contentOffset;
  
  // paddingTop
  // paddingBottom
  // paddingLeft
  // paddingRight
  RectangleEdges<Float> padding;
  
  // MARK: - Init
  // ------------

  RNIBaseViewState() = default;
  
  RNIBaseViewState(
    Size frameSize_,
    Point contentOffset_,
    RectangleEdges<Float> padding_
  ) :
    frameSize(frameSize_),
    contentOffset(contentOffset_),
    padding(padding_)
  {
    // no-op
  };
  
  RNIBaseViewState(
    RNIBaseViewState const &previousState
  ) :
    frameSize(previousState.frameSize),
    contentOffset(previousState.contentOffset)
  {
    // no-op
  }

  RNIBaseViewState(
    RNIBaseViewState const &previousState,
    folly::dynamic data
  ) {
  
    this->frameSize = [&]() {
      const Float frameHeight = data["frameHeight"] == nullptr
        ? previousState.frameSize.height
        : (Float)data["frameHeight"].getDouble();
        
      const Float frameWidth = data["frameWidth"] == nullptr
        ? previousState.frameSize.width
        : (Float)data["frameWidth"].getDouble();
        
      Size frameSize = {};
      frameSize.width = frameWidth;
      frameSize.height = frameHeight;
      
      return frameSize;
    }();
    
    this->contentOffset = [&]() {
      const Float contentOffsetX = data["contentOffsetX"] == nullptr
        ? previousState.contentOffset.x
        : (Float)data["contentOffsetX"].getDouble();
        
      const Float contentOffsetY = data["contentOffsetY"] == nullptr
        ? previousState.contentOffset.y
        : (Float)data["contentOffsetY"].getDouble();
    
      Point contentOffset = {};
      contentOffset.x = contentOffsetX;
      contentOffset.y = contentOffsetY;
      
      return contentOffset;
    }();
    
    const Float paddingTop = data["paddingTop"] == nullptr
      ? previousState.padding.top
      : (Float)data["paddingTop"].getDouble();
      
    const Float paddingBottom = data["paddingBottom"] == nullptr
      ? previousState.padding.bottom
      : (Float)data["paddingBottom"].getDouble();
      
    const Float paddingLeft = data["paddingLeft"] == nullptr
      ? previousState.padding.left
      : (Float)data["paddingLeft"].getDouble();
      
    const Float paddingRight = data["paddingRight"] == nullptr
      ? previousState.padding.right
      : (Float)data["paddingRight"].getDouble();
  };
  
  // MARK: - Methods
  // ---------------
  
  folly::dynamic getDynamic() const;
};

} // namespace facebook::react
#endif
