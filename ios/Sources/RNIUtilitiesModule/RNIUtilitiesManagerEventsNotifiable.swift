//
//  RNIUtilitiesManagerEventsNotifiable.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation
import DGSwiftUtilities


public protocol RNIUtilitiesManagerEventsNotifiable: Singleton {
  
  func notifyOnJavascriptModuleDidLoad();
  
  func notifyOnSharedEnvDidUpdate(
    sharedEnv: Dictionary<String, Any>,
    newEntries: Dictionary<String, Any>,
    oldEntries: Dictionary<String, Any>
  );
};
