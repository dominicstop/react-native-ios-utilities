//
//  RNIBaseViewUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/14/24.
//

#define RNI_EXPORT_VIEW_PROPERTY(propName, type) \
  RCT_REMAP_VIEW_PROPERTY(propName, reactPropHandler.propName, type)
  
#define RNI_EXPORT_VIEW_EVENT(eventName, type) \
  RCT_REMAP_VIEW_PROPERTY(eventName, reactEventHandler.eventName, type)
