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

  rawProps.iterateOverValues([&propsMap](
    react::RawPropsPropNameHash hash,
    const char *name,
    const react::RawValue &value
  ) {
    std::string propName(name);
    propsMap[propName] = (folly::dynamic)value;
    
    std::cout << "propName: " << propName << std::endl;
    std::cout << "value: " << (folly::dynamic)value << "\n" << std::endl;
  });
}
#endif

};
