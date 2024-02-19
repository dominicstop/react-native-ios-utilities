//
//  RNIUtiltiesModule+RNIUtilitiesManagerEventsNotifiable.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/16/24.
//

import Foundation
import DGSwiftUtilities

extension RNIUtilitiesManager: RNIUtilitiesManagerEventsNotifiable {

  public func notifyOnJavascriptModuleDidLoad() {
    // no-op
  };
  
  public func notifyOnSharedEnvDidUpdate(
    sharedEnv: Dictionary<String, Any>,
    newEntries: Dictionary<String, Any>,
    oldEntries: Dictionary<String, Any>
  ) {
  
    VerboseErrorSharedEnv.overrideShouldLogFileMetadata = try? sharedEnv.getValueFromDictionary(
      forKey: "overrideShouldLogFileMetadata",
      type: Bool.self
    );
    
    VerboseErrorSharedEnv.overrideShouldLogFilePath = try? sharedEnv.getValueFromDictionary(
      forKey: "overrideShouldLogFilePath",
      type: Bool.self
    );
    
    VerboseErrorSharedEnv.overrideEnableLogStackTrace = try? sharedEnv.getValueFromDictionary(
      forKey: "overrideEnableLogStackTrace",
      type: Bool.self
    );
    
    if let flag = try? sharedEnv.getValueFromDictionary(
      forKey: "debugShouldLogViewRegistryEntryRemoval",
      type: Bool.self
    ) {
      RNIHelpers.debugShouldLogViewRegistryEntryRemoval = flag;
    };
  };
};
