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
        let detachedView = try? RNIModuleHelpers.getView(
          withErrorType: RNIUtilitiesError.self,
          forNode: reactTag,
          type: RNIDetachedView.self
        );
        
        guard let detachedView = detachedView else {
          promise.resolve();
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
