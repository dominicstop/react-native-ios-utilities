//
//  RNIBaseViewProps.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//
#if __cplusplus
#include "RNIBaseViewProps.h"

#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/core/propsConversions.h>

#include <iostream>

namespace facebook::react {

RNIBaseViewProps::RNIBaseViewProps(
  const PropsParserContext &context,
  const RNIBaseViewProps &sourceProps,
  const RawProps &rawProps
): ViewProps(context, sourceProps, rawProps) {
  
  std::unordered_map<std::string, folly::dynamic> propsMap = std::move(sourceProps.propsMap);
  
  #if REACT_NATIVE_TARGET_VERSION >= 76
  /// PR-#6 by: SamuelScheit
  /// Link: https://github.com/dominicstop/react-native-ios-utilities/pull/6
  ///
  /// * This is more performant
  /// * `iterateOverValues` has been deprecated on RN 0.76+
  ///
  const auto& dynamicProps = static_cast<folly::dynamic>(rawProps);
  
  for (const auto& pair : dynamicProps.items()) {
    const auto& name = pair.first.getString();
    propsMap[name] = pair.second;
  };
  #else
  rawProps.iterateOverValues([&propsMap](
    react::RawPropsPropNameHash hash,
    const char *name,
    const react::RawValue &value
  ) {
    std::string propName(name);
    propsMap[propName] = (folly::dynamic)value;
  });
  #endif

  this->propsMap = propsMap;
}
#endif

};
