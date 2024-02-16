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
    RNICleanableViewRegistryEnv.updateEnv(usingDict: sharedEnv);
  };
};
