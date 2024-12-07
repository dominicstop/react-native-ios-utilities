//
//  RNIWrapperViewComponentDescriptor.h
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

#if __cplusplus
#pragma once

#include "RNIWrapperViewShadowNode.h"
#include "RNIBaseViewComponentDescriptor.h"

#include "RNIBaseViewState.h"
#include <react/renderer/core/ConcreteComponentDescriptor.h>


namespace facebook::react {

class RNIWrapperViewComponentDescriptor final : public RNIBaseViewComponentDescriptor<
  RNIWrapperViewShadowNode,
  RNIWrapperViewComponentName
> {
  
public:
  using RNIBaseViewComponentDescriptor::RNIBaseViewComponentDescriptor;
};

} // namespace facebook::react
#endif
