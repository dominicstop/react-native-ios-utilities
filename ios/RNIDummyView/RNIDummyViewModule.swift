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
    
    Function("notifyOnComponentWillUnmount") { (reactTag: Int, isManuallyTriggered: Bool) in
      guard let bridge = RNIHelpers.bridge else { return };
    
      let dummyView = RNIHelpers.getView(
        forNode: reactTag as NSNumber,
        type: RNIDummyView.self,
        bridge: bridge
      );
      
      guard let dummyView = dummyView else { return };
      dummyView.notifyOnComponentWillUnmount(isManuallyTriggered: isManuallyTriggered);
    };

    View(RNIDummyView.self) {
      Events("onReactTagDidSet");
    
      Prop("name") { (view: UIView, prop: String) in
        // placeholder
        print(prop)
      };
    };
  };
};
