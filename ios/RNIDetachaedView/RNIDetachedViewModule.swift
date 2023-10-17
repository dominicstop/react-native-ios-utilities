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
      
      DispatchQueue.main.async {
        guard let bridge = RNIHelpers.bridge else {
          let error = RNIUtilitiesError(errorCode: .nilReactBridge);
          promise.reject(error);
          return;
        };
      
        let detachedView = RNIHelpers.getView(
          forNode: reactTag as NSNumber,
          type: RNIDetachedView.self,
          bridge: bridge
        );
        
        guard let detachedView = detachedView else {
          let error = RNIUtilitiesError(errorCode: .viewNotFoundForReactTag);          
          promise.reject(error);
          return;
        };
        
        detachedView.notifyOnComponentWillUnmount(
          isManuallyTriggered: isManuallyTriggered
        );
        
        promise.resolve();
      };
    };
    
    View(RNIDetachedView.self) {
      Events("onViewDidDetach");
    
      Prop("shouldCleanupOnComponentWillUnmount") {
        $0.shouldCleanupOnComponentWillUnmount = $1;
      };
    };
  };
};
