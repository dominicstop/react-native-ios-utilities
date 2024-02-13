//
//  RNIUtilitiesModule.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/14/24.
//

import UIKit
import ExpoModulesCore

public class RNIUtilitiesModule: Module {

  public func definition() -> ModuleDefinition {
  
    Name("RNIUtilitiesModule")

    AsyncFunction("notifyOnComponentWillUnmount") {
      (reactTag: Int, commandParams: Dictionary<String, Any>, promise: Promise) in
      
      DispatchQueue.main.async {
        defer {
          promise.resolve();
        };
        
        let entry = RNICleanableViewRegistryShared.getEntry(forKey: reactTag);
        guard let entry = entry else { return };
        
        let shouldIgnoreCleanupTriggers = try? commandParams.getValueFromDictionary(
          forKey: "shouldIgnoreCleanupTriggers",
          type: Bool.self
        );
        
        let shouldForceCleanup = try? commandParams.getValueFromDictionary(
          forKey: "shouldForceCleanup",
          type: Bool.self
        );
        
        let shouldTriggerCleanup =
             shouldIgnoreCleanupTriggers ?? false
          || entry.viewCleanupMode.triggers.contains(.reactComponentWillUnmount);
          
        guard shouldTriggerCleanup else { return };
        
        try? RNICleanableViewRegistryShared.notifyCleanup(
          forKey: reactTag,
          sender: .reactModule(
            reactTag: reactTag,
            commandArguments: [:]
          ),
          shouldForceCleanup: shouldForceCleanup ?? false,
          cleanupTrigger: .reactComponentWillUnmount
        );
      };
    };
  };
};

