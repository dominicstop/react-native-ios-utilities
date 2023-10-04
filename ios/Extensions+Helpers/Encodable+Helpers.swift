//
//  Encodable+Helpers.swift
//  nativeUIModulesTest
//
//  Created by Dominic Go on 7/6/20.
//

import Foundation

public extension Encodable {

  subscript(key: String) -> Any? {
    guard let dictionary = self.dictionary else { return nil };
    return dictionary[key];
  };
  
  var dictionary: [String: Any]? {
    guard let encoder = try? JSONEncoder().encode(self),
          let json = try? JSONSerialization.jsonObject(with: encoder)
    else { return nil };
  
    return json as? [String: Any];
  };
  
  func jsonData() throws -> Data {
    let encoder = JSONEncoder();
    encoder.outputFormatting = .prettyPrinted;
    
    if #available(iOS 10.0, *) {
      encoder.dateEncodingStrategy = .iso8601;
      
    } else {
      encoder.dateEncodingStrategy = .millisecondsSince1970;
    };
    
    return try encoder.encode(self);
  };
};
