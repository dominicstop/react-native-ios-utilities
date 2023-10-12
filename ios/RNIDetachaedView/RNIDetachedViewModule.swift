//
//  RNIDetachedViewModule.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import ExpoModulesCore

public class RNIDetachedViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNIDetachedView");
    
    AsyncFunction("notifyOnComponentWillUnmount") {
      (reactTag: Int, isManuallyTriggered: Bool, promise: Promise) in
      
      guard let bridge = RNIHelpers.bridge else {
        let error = RNIError(
          domain: "react-native-ios-utilities",
          description: "Could not get bridge instance",
          extraDebugInfo: "reactTag: \(reactTag)"
        );
        
        promise.reject(error);
        return;
      };
    
      let detachedView = RNIHelpers.getView(
        forNode: reactTag as NSNumber,
        type: RNIDetachedView.self,
        bridge: bridge
      );
      
      guard let detachedView = detachedView else {
        let error = RNIError(
          domain: "react-native-ios-utilities",
          description: "Could not get view instance",
          extraDebugInfo: "reactTag: \(reactTag)"
        );
        
        promise.reject(error);
        return;
      };
      
      detachedView.notifyOnComponentWillUnmount(
        isManuallyTriggered: isManuallyTriggered
      );
      
      promise.resolve();
    };
    
    AsyncFunction("onViewDidDetach") { (reactTag: Int, promise: Promise) in
      guard let bridge = RNIHelpers.bridge else {
        let error = RNIError(
          domain: "react-native-ios-utilities",
          description: "Could not get bridge instance",
          extraDebugInfo: "reactTag: \(reactTag)"
        );
        
        promise.reject(error);
        return;
      };
    
      let detachedView = RNIHelpers.getView(
        forNode: reactTag as NSNumber,
        type: RNIDetachedView.self,
        bridge: bridge
      );
      
      guard let detachedView = detachedView else {
        let error = RNIError(
          domain: "react-native-ios-utilities",
          description: "Could not get view instance",
          extraDebugInfo: "reactTag: \(reactTag)"
        );
        
        promise.reject(error);
        return;
      };
      
      detachedView.onViewDidDetach();
      promise.resolve();
    };
    
    View(RNIDetachedView.self) {
      Events("onReactTagDidSet");
    
      Prop("shouldCleanupOnComponentWillUnmount") {
        $0.shouldCleanupOnComponentWillUnmount = $1;
      };
    };
  };
};
