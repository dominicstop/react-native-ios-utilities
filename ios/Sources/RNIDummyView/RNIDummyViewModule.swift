//
//  RNIDummyViewModule.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import ExpoModulesCore

public class RNIDummyViewModule: Module {
  public func definition() -> ModuleDefinition {
    Name("RNIDummyView");
    
    AsyncFunction("notifyOnComponentWillUnmount") {
      (reactTag: Int, isManuallyTriggered: Bool, promise: Promise) in
      
      DispatchQueue.main.async {
        do {
          let dummyView = try RNIModuleHelpers.getView(
            withErrorType: RNIUtilitiesError.self,
            forNode: reactTag,
            type: RNIDummyView.self
          );
          
          dummyView.notifyOnComponentWillUnmount(
            isManuallyTriggered: isManuallyTriggered
          );
          
          promise.resolve();
        
        } catch let error {
          promise.reject(error);
          return;
        };
      };
    };

    View(RNIDummyView.self) {
      Prop("shouldCleanupOnComponentWillUnmount") {
        $0.shouldCleanupOnComponentWillUnmount = $1;
      };
    };
  };
};
