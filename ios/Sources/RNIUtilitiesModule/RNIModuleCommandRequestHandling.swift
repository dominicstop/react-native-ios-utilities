//
//  RNIModuleCommandRequestHandling.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/25/24.
//

import Foundation
import DGSwiftUtilities


public protocol RNIModuleCommandRequestHandling: Singleton {

  // MARK: Types
  // -----------

  associatedtype ClassType = Self;
  
  typealias CommandArguments = Dictionary<String, Any>;

  typealias Resolve = (_ payload: CommandArguments) -> Void;
  
  typealias Reject = (_ errorMessage: String) -> Void;
  
  typealias Promise = (
    _ payload: CommandArguments,
    _ resolve: Resolve
  ) throws -> Void;
  
  typealias PromiseCommand = (_ instance: ClassType) -> Promise;
  
  // MARK: Static Properties
  // -----------------------
  
  static var moduleName: String { get };
  
  static var commandMapPromise: [String: PromiseCommand] { get };
  
  static var initialSharedValues: [String: Any] { get };
};
