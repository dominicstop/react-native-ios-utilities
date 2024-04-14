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
    
    AsyncFunction("getAllSFSymbols") { (promise: Promise) in
      #if DEBUG
      guard let sfSymbolsBundle = Bundle(identifier: "com.apple.SFSymbolsFramework"),
            let bundlePath = sfSymbolsBundle.path(forResource: "CoreGlyphs", ofType: "bundle"),
            let bundle = Bundle(path: bundlePath),
            let resourcePath = bundle.path(forResource: "symbol_search", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: resourcePath)
      else {
        let error = RNIUtilitiesError(
          errorCode: .unexpectedNilValue,
          description: "Unable to get bundle for SFSymbols"
        );
        promise.reject(error);
        return;
      };
      
      promise.resolve(plist);
      #else
      let error = RNIUtilitiesError(
        errorCode: .runtimeError,
        description: "Not supported in production builds"
      );
      promise.reject(error);
      #endif
    };
    
    View(RNIImageView.self) {
      Prop("imageConfig"){
        $0.imageConfigProp = $1;
      };
      
      Prop("preferredSymbolConfiguration"){
        $0.preferredSymbolConfigurationProp = $1;
      };
    };
  };
};
