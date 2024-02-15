//
//  RNICleanableViewRegistry+RNIUtilitiesManagerEventsNotifiable.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation

extension RNICleanableViewRegistry: RNIUtilitiesManagerEventsNotifiable {

  public func notifyOnJavascriptModuleDidLoad() {
    // no-op
  };
  
  public func notifyOnSharedEnvDidUpdate(
    sharedEnv: Dictionary<String, Any>,
    newEntries: Dictionary<String, Any>,
    oldEntries: Dictionary<String, Any>
  ) {
    guard let env = try? RNICleanableViewRegistryEnv(fromDict: sharedEnv)
    else { return };
    
    Self.shouldGloballyDisableCleanup = env.shouldGloballyDisableCleanup;
    Self.debugShouldLogCleanup = env.debugShouldLogCleanup;
    Self.debugShouldLogRegister = env.debugShouldLogRegister;
  };
};
