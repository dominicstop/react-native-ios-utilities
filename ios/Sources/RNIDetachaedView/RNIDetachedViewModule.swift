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
        do {
          let detachedView = try RNIModuleHelpers.getView(
            withErrorType: RNIUtilitiesError.self,
            forNode: reactTag,
            type: RNIDetachedView.self
          );
          
          detachedView.notifyOnComponentWillUnmount(
            isManuallyTriggered: isManuallyTriggered
          );
          
          promise.resolve();
        
        } catch let error {
          promise.reject(error);
          return;
        };
      };
    };
    
    View(RNIDetachedView.self) {
      Events("onViewDidDetach");
    
      Prop("shouldCleanupOnComponentWillUnmount") {
        $0.shouldCleanupOnComponentWillUnmount = $1;
      };
      
      Prop("contentTargetMode") {
        $0.contentTargetModeProp = $1;
      };
    };
  };
};
