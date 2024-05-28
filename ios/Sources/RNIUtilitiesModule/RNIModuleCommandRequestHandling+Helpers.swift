//
//  RNIModuleCommandRequestHandling+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/25/24.
//

import Foundation
import DGSwiftUtilities


public extension RNIModuleCommandRequestHandling {

  func invokePromiseCommand(
    named commandName: String,
    withCommandArguments commandArgs: CommandArguments,
    resolve: Resolve
  ) throws {
    
    guard let matchingCommand = Self.commandMapPromise[commandName] else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "No associated command found for the provided `commandName`",
        extraDebugValues: [
          "commandName": commandName,
        ]
      );
    };
    
    try matchingCommand(self as! ClassType)(commandArgs, resolve);
  };
  
  // MARK: "Shared Values"-Related
  // -----------------------------
  
  var sharedValues: NSMutableDictionary {
    let result = RNIUtilitiesManager.shared.getAllModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    return result;
  };
  
  func getSharedValue(forKey key: String) -> Any? {
    return RNIUtilitiesManager.shared.getModuleSharedValue(
      forModuleNamed: Self.moduleName,
      forKey: key
    );
  }
  
  func setSharedValue(forKey key: String, withValue value: Any?){
    RNIUtilitiesManager.shared.setModuleSharedValue(
      forModuleNamed: Self.moduleName,
      forKey: key,
      withValue: value as Any
    );
  };
  
  func overwriteSharedValues(withDict dict: Dictionary<String, Any>){
    let sharedValues = RNIUtilitiesManager.shared.getAllModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    sharedValues.removeAllObjects();
    sharedValues.setValuesForKeys(dict);
  };
  
  func clearSharedValues(){
    let sharedValues = RNIUtilitiesManager.shared.getAllModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    sharedValues.removeAllObjects();
  };
};
