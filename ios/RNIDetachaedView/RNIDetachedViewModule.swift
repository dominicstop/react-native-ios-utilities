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
    
    Function("notifyOnComponentWillUnmount") { (reactTag: Int, isManuallyTriggered: Bool) in
      guard let bridge = RNIHelpers.bridge else { return };
    
      let detachedView = RNIHelpers.getView(
        forNode: reactTag as NSNumber,
        type: RNIDetachedView.self,
        bridge: bridge
      );
      
      guard let detachedView = detachedView else { return };
      detachedView.notifyOnComponentWillUnmount(isManuallyTriggered: isManuallyTriggered);
    };
    
    Function("onViewDidDetach") { (reactTag: Int) in
      guard let bridge = RNIHelpers.bridge else { return };
    
      let detachedView = RNIHelpers.getView(
        forNode: reactTag as NSNumber,
        type: RNIDetachedView.self,
        bridge: bridge
      );
      
      guard let detachedView = detachedView else { return };
      detachedView.onViewDidDetach();
    };
    
    View(RNIDetachedView.self) {
      Events("onReactTagDidSet");
    
      Prop("shouldCleanupOnComponentWillUnmount") { (view: RNIDetachedView, prop: Bool) in
        view.shouldCleanupOnComponentWillUnmount = prop;
      };
    };
  };
};
