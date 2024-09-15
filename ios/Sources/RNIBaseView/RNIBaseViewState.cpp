//
//  RNIBaseViewState.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/7/24.
//

#if __cplusplus
#include "RNIBaseViewState.h"


namespace facebook::react {

folly::dynamic RNIBaseViewState::getDynamic() const {
  
  folly::dynamic map = folly::dynamic::object;
  
  map["shouldSetSize"] = this->shouldSetSize;
  map["frameWidth" ] = this->frameSize.width;
  map["frameHeight"] = this->frameSize.height;
  
  map["contentOffsetX"] = this->contentOffset.x;
  map["contentOffsetY"] = this->contentOffset.y;
  
  map["shouldSetPadding"] = this->shouldSetPadding;
  map["paddingTop"   ] = this->padding.top;
  map["paddingBottom"] = this->padding.bottom;
  map["paddingLeft"  ] = this->padding.left;
  map["paddingRight" ] = this->padding.right;
  
  map["shouldSetPositionType"] = this->shouldSetPositionType;
  map["positionType"] = (int)this->positionType;
  
  
  return map;
}

} // facebook::react
#endif
