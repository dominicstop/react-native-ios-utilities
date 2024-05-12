//
//  RNIBaseViewProps.cpp
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/12/24.
//
#if __cplusplus
#pragma once

#include <react/renderer/components/view/ViewProps.h>

namespace facebook::react {

class RNIBaseViewProps : public ViewProps {
public:
  RNIBaseViewProps() = default;
  
  RNIBaseViewProps(
    const PropsParserContext& context,
    const RNIBaseViewProps &sourceProps,
    const RawProps &rawProps
  );

#pragma mark - Props

  std::unordered_map<std::string, folly::dynamic> propsMap;
};

}
#endif
