//
//  RNIDummyTestViewComponentDescriptor.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//
#if __cplusplus
#pragma once

#include "RNIDummyTestViewShadowNode.h"
#include "RNIBaseViewComponentDescriptor.h"

#include <react-native-ios-utilities/RNIBaseViewState.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>


namespace facebook::react {

class RNIDummyTestViewComponentDescriptor final
  : public RNIBaseViewComponentDescriptor<RNIDummyTestViewShadowNode> {
  
public:
  using RNIBaseViewComponentDescriptor::RNIBaseViewComponentDescriptor;
};

} // namespace facebook::react
#endif
