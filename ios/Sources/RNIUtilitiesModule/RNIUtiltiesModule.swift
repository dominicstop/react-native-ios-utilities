//
//  RNIUtilitiesModule.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/14/24.
//

import UIKit
import ExpoModulesCore
import DGSwiftUtilities

public protocol Singleton {
  static var shared: Self { get };
  
  init();
};

public class RNIUtilitiesModule: Module {

  public func definition() -> ModuleDefinition {
  
    Name("RNIUtilitiesModule");
    
    Function("notifyOnJavascriptModuleDidLoad") {
      DispatchQueue.main.async {
        RNIUtilitiesManagerShared.eventDelegates.invoke {
          $0.notifyOnJavascriptModuleDidLoad();
        };
      };
    };
    
    Function("setSharedEnv"){ (env: Dictionary<String, Any>) in
      DispatchQueue.main.async {
        RNIUtilitiesManagerShared.appendToSharedEnv(newEntries: env);
      };
    };

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

