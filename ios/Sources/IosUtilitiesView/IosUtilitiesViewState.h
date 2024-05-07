//
//  IosUtilitiesViewState.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/6/24.
//

#pragma once

#include <react/renderer/graphics/Float.h>
#include <react/renderer/core/graphicsConversions.h>

#include <folly/dynamic.h>

namespace facebook::react {

class IosUtilitiesViewState {
public:
  
  // frameHeight
  // frameWidth
  Size frameSize;
  
  // contentOffsetX
  // contentOffsetY
  Point contentOffset;
  
  // MARK: - Init
  // ------------

  IosUtilitiesViewState() = default;
  
  IosUtilitiesViewState(
    Size frameSize_,
    Point contentOffset_
  ) :
    frameSize(frameSize_),
    contentOffset(contentOffset_
  ) {
    // no-op
  };

  IosUtilitiesViewState(
    IosUtilitiesViewState const &previousState,
    folly::dynamic data
  ) {
  
    Size frameSize = {};
    frameSize.height = (Float)data["frameHeight"].getDouble();
    frameSize.width = (Float)data["frameWidth"].getDouble();
    
    this->frameSize = frameSize;
    
    Point contentOffset = {};
    contentOffset.x = (Float)data["contentOffsetX"].getDouble();
    contentOffset.y = (Float)data["contentOffsetY"].getDouble();
    
    this->contentOffset = contentOffset;
  };
  
  // MARK: - Methods
  // ---------------
  
  folly::dynamic getDynamic() const;
};

} // namespace facebook::react
