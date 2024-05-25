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

  typealias Resolve = (_ payload: Dictionary<String, Any>) -> Void;
  
  typealias Reject = (_ errorMessage: String) -> Void;
  
  typealias Promise = (_ resolve: Resolve, _ reject: Reject) -> Void;
  
  typealias PromiseCommand = (_ instance: ClassType) -> Promise;
  
  // MARK: Static Properties
  // -----------------------
  
  static var moduleName: String { get };
  
  static var commandMapPromise: [String: PromiseCommand] { get };
};
