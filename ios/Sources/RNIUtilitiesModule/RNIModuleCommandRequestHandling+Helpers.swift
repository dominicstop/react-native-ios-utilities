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
};
