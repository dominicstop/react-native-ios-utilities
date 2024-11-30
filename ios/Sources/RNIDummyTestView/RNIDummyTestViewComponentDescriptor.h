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

#if __has_include(<react_native_ios_utilities/RNIBaseViewState.h>)
#import <react_native_ios_utilities/RNIBaseViewState.h>
#else
#include <react-native-ios-utilities/RNIBaseViewState.h>
#endif
#include <react/renderer/core/ConcreteComponentDescriptor.h>


namespace facebook::react {

class RNIDummyTestViewComponentDescriptor final : public RNIBaseViewComponentDescriptor<
  RNIDummyTestViewShadowNode,
  RNIDummyTestViewComponentName
> {
  
public:
  using RNIBaseViewComponentDescriptor::RNIBaseViewComponentDescriptor;
};

} // namespace facebook::react
#endif
