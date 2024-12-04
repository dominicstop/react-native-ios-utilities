//
//  RNIBaseViewUtils.h
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/14/24.
//

#if RCT_NEW_ARCH_ENABLED
#define RNI_EXPORT_VIEW_PROPERTY(propName, type) \
  RCT_CUSTOM_VIEW_PROPERTY(propName, id, RNIBaseView){}

#define RNI_EXPORT_VIEW_EVENT(eventName, type) \
  RCT_CUSTOM_VIEW_PROPERTY(eventName, id, RNIBaseView){}
#else  
#define RNI_EXPORT_VIEW_PROPERTY(propName, type) \
  RCT_REMAP_VIEW_PROPERTY(propName, reactPropHandler.propName, type)

#define RNI_EXPORT_VIEW_EVENT(eventName, type) \
  RCT_REMAP_VIEW_PROPERTY(eventName, reactEventHandler.eventName, type)
#endif
