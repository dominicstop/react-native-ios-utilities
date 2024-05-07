//
//  IosUtilitiesViewState.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#include "IosUtilitiesViewState.h"

namespace facebook::react {

folly::dynamic IosUtilitiesViewState::getDynamic() const  {
  
  folly::dynamic map = folly::dynamic::object;
  map["frameWidth"] = this->frameSize.width;
  map["frameHeight"] = this->frameSize.height;
  
  map["contentOffsetX"] = this->contentOffset.x;
  map["contentOffsetY"] = this->contentOffset.y;
  
  return map;
}

} // facebook::react
