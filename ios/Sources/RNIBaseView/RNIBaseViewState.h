//
//  RNIBaseViewState.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#pragma once

#include <react/renderer/graphics/Float.h>
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
  
  // MARK: - Init
  // ------------

  RNIBaseViewState() = default;
  
  RNIBaseViewState(
    Size frameSize_,
    Point contentOffset_
  ) :
    frameSize(frameSize_),
    contentOffset(contentOffset_)
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
  
    const float frameHeight = [&]() {
      if(data["frameHeight"] == nullptr){
        return previousState.frameSize.height;
      };
      
      return (Float)data["frameHeight"].getDouble();
    }();
    
    const float frameWidth = [&]() {
      if(data["frameWidth"] == nullptr){
        return previousState.frameSize.width;
      };
      
      return (Float)data["frameWidth"].getDouble();
    }();
    
    this->frameSize = [&]() {
      Size frameSize = {};
      frameSize.width = frameWidth;
      frameSize.height = frameHeight;
      
      return frameSize;
    }();
    
    const float contentOffsetX = [&]() {
      if(data["contentOffsetX"] == nullptr){
        return previousState.contentOffset.x;
      };
      
      return (Float)data["contentOffsetX"].getDouble();
    }();
    
    const float contentOffsetY = [&]() {
      if(data["contentOffsetY"] == nullptr){
        return previousState.contentOffset.y;
      };
      
      return (Float)data["contentOffsetY"].getDouble();
    }();
    
    this->contentOffset = [&]() {
      Point contentOffset = {};
      contentOffset.x = contentOffsetX;
      contentOffset.y = contentOffsetY;
      
      return contentOffset;
    }();
  };
  
  // MARK: - Methods
  // ---------------
  
  folly::dynamic getDynamic() const;
};

} // namespace facebook::react
