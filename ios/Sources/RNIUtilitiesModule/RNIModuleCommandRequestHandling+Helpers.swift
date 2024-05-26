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
  
  var sharedValues: FauxDictionary<String, Any> {
    .init { key, value in
      self.setSharedValue(forKey: key, withValue: value);
      
    } getter: { key in
      self.getSharedValue(forKey: key);
    };
  };
  
  func getSharedValue(forKey key: String) -> Any? {
    let sharedValues = RNIUtilitiesManagerShared.getModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    return sharedValues[key];
  };
  
  func setSharedValue(forKey key: String, withValue value: Any?){
    let sharedValues = RNIUtilitiesManagerShared.getModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    sharedValues[key] = value;
  };
  
  func overwriteSharedValues(withDict dict: Dictionary<String, Any>){
    let sharedValues = RNIUtilitiesManagerShared.getModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    sharedValues.removeAllObjects();
    sharedValues.setValuesForKeys(dict);
  };
  
  func clearSharedValues(){
    let sharedValues = RNIUtilitiesManagerShared.getModuleSharedValues(
      forModuleName: Self.moduleName
    );
    
    sharedValues.removeAllObjects();
  };
};
