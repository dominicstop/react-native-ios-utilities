//
//  RNIDetachedViewModule.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import ExpoModulesCore
import DGSwiftUtilities

public class RNIDetachedViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNIDetachedView");
    
    AsyncFunction("debugAttachToWindow") { (reactTag: Int, promise: Promise) in
      
      DispatchQueue.main.async {
        do {
          let detachedView = try RNIModuleHelpers.getView(
            withErrorType: RNIUtilitiesError.self,
            forNode: reactTag,
            type: RNIDetachedView.self
          );
          
          try detachedView.detach();
          
          guard let window = UIApplication.shared.activeWindow else {
            throw RNIUtilitiesError(
              errorCode: .unexpectedNilValue,
              description: "Could not get `window` instance"
            );
          };
          
          guard let contentView = detachedView.contentView else {
            throw RNIUtilitiesError(
              errorCode: .unexpectedNilValue,
              description: "Could not get `detachedView.contentView`"
            );
          };
          
          window.addSubview(contentView);
          promise.resolve();
        
        } catch let error {
          promise.reject(error);
          return;
        };
      };
    };
    
    View(RNIDetachedView.self) {
      Events("onViewDidDetach");
    
      Prop("internalViewCleanupMode") {
        $0.internalViewCleanupModeRaw = $1;
      };
      
      Prop("contentTargetMode") {
        $0.contentTargetModeProp = $1;
      };
    };
  };
};
