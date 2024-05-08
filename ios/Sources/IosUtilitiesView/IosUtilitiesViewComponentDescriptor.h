//
//  IosUtilitiesViewComponentDescriptor.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/5/24.
//
#if __cplusplus
#pragma once

#include "IosUtilitiesViewShadowNode.h"
#include "RNIBaseViewComponentDescriptor.h"

#include <react-native-ios-utilities/RNIBaseViewState.h>
#include <react/renderer/core/ConcreteComponentDescriptor.h>

namespace facebook::react {

class IosUtilitiesViewComponentDescriptor final
  : public RNIBaseViewComponentDescriptor<IosUtilitiesViewShadowNode> {
  
public:
  using RNIBaseViewComponentDescriptor::RNIBaseViewComponentDescriptor;
};

} // namespace facebook::react
#endif
