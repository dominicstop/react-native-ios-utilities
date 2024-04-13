//
//  RNIImageViewModule.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 4/13/24.
//

import UIKit
import ExpoModulesCore


public class RNIImageViewModule: Module {

  public func definition() -> ModuleDefinition {
    Name("RNIImageView");
    
    View(RNIImageView.self) {
      Prop("imageConfig"){
        $0.imageConfigProp = $1;
      };
    };
  };
};
