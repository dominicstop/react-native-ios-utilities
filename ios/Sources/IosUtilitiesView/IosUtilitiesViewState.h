//
//  IosUtilitiesViewState.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/6/24.
//

#pragma once

#ifdef ANDROID
#include <folly/dynamic.h>
#include <react/renderer/mapbuffer/MapBuffer.h>
#include <react/renderer/mapbuffer/MapBufferBuilder.h>
#endif

namespace facebook::react {

class IosUtilitiesViewState {
public:
  IosUtilitiesViewState() = default;
  
#ifdef ANDROID
  IosUtilitiesViewState(IosUtilitiesViewState const &previousState, folly::dynamic data){};
  
  folly::dynamic getDynamic() const {
    return {};
  }；
  
  MapBuffer getMapBuffer() const {
    return MapBufferBuilder::EMPTY();
  };
#endif
};

} // namespace facebook::react
