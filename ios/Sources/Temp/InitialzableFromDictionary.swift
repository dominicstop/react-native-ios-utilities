//
//  InitializableFromDictionary.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/22/23.
//

import Foundation


// TODO: Move to `DGSwiftUtilities`
public protocol InitializableFromDictionary {
  
  init(fromDict dict: Dictionary<String, Any>) throws;
};

extension InitializableFromDictionary {
  
  // For backwards compatibility
  @available(*, deprecated, message: "Please use init(fromDict:) instead...")
  init?(dict: Dictionary<String, Any>){
    guard let value = try? Self.init(fromDict: dict) else { return nil };
    self = value;
  };
};
