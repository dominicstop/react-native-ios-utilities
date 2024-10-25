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

  const auto& dynamic = static_cast<folly::dynamic>(rawProps);

  for (const auto& pair : dynamic.items()) {
      const auto& name = pair.first.getString();
      shadowNodeProps->setProp(
          context,
          RAW_PROPS_KEY_HASH(name),
          name.c_str(),
          RawValue(pair.second));
    }
  }
  
  this->propsMap = propsMap;
}
#endif

};
