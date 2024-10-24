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

  const auto& dynamicProps = static_cast<folly::dynamic>(rawProps);

  for (const auto& pair : dynamicProps.items()) {
    const auto& name = pair.first.getString();
    propsMap[name] = pair.second;
  }
  
  this->propsMap = propsMap;
}
#endif

};
