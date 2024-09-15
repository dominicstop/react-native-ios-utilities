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

#include <yoga/YGEnums.h>


namespace facebook::react {

class RNIBaseViewState {
public:
  
  using ConcreteState = ConcreteState<RNIBaseViewState>;
  using SharedConcreteState = std::shared_ptr<const ConcreteState>;
  
  // MARK: Properties
  // ----------------
  
  // frameHeight
  // frameWidth
  Size frameSize;
  bool shouldSetSize = false;
  
  // contentOffsetX
  // contentOffsetY
  Point contentOffset;
  
  // paddingTop
  // paddingBottom
  // paddingLeft
  // paddingRight
  RectangleEdges<Float> padding;
  bool shouldSetPadding = false;
  
  YGPositionType positionType;
  bool shouldSetPositionType = false;
  
  // MARK: - Init
  // ------------

  RNIBaseViewState() = default;
  
  RNIBaseViewState(
    Size frameSize_,
    Point contentOffset_,
    RectangleEdges<Float> padding_,
    YGPositionType positionType_
  ) :
    frameSize(frameSize_),
    contentOffset(contentOffset_),
    padding(padding_),
    positionType(positionType_)
  {
    // no-op
  };
  
  RNIBaseViewState(
    RNIBaseViewState const &previousState
  ) :
    shouldSetSize(previousState.shouldSetSize),
    shouldSetPadding(previousState.shouldSetPadding),
    shouldSetPositionType(previousState.shouldSetPositionType),
    frameSize(previousState.frameSize),
    contentOffset(previousState.contentOffset),
    padding(previousState.padding),
    positionType(previousState.positionType)
  {
    // no-op
  }

  RNIBaseViewState(
    RNIBaseViewState const &previousState,
    folly::dynamic data
  ) {
  
    this->shouldSetSize = data["shouldSetSize"] == nullptr
      ? previousState.shouldSetSize
      : data["shouldSetSize"].getBool();
      
    this->shouldSetPadding = data["shouldSetPadding"] == nullptr
      ? previousState.shouldSetPadding
      : data["shouldSetPadding"].getBool();
      
    this->shouldSetPositionType = data["shouldSetPositionType"] == nullptr
      ? previousState.shouldSetPositionType
      : data["shouldSetPositionType"].getBool();
      
    this->frameSize = [&]() {
      const Float frameHeight = data["frameHeight"] == nullptr
        ? previousState.frameSize.height
        : (Float)data["frameHeight"].getDouble();
        
      const Float frameWidth = data["frameWidth"] == nullptr
        ? previousState.frameSize.width
        : (Float)data["frameWidth"].getDouble();
        
      Size frameSize = {};
      frameSize.width  = frameWidth;
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
    
    this->padding = [&]() {
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
        
      RectangleEdges<Float> padding = {};
      padding.top    = paddingTop;
      padding.bottom = paddingBottom;
      padding.left   = paddingLeft;
      padding.right  = paddingRight;
      
      return padding;
    }();
    
    this->positionType = data["positionType"] == nullptr
      ? previousState.positionType
      : (YGPositionType)data["positionType"].getInt();
  };
  
  // MARK: - Methods
  // ---------------
  
  folly::dynamic getDynamic() const;
};

} // namespace facebook::react
#endif
