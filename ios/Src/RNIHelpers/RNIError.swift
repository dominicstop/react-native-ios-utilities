//
//  RNINavigatorError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation


class RNIBaseError<E: RawRepresentable>: Error where E.RawValue == String  {
  
  var code: E;
  let domain: String;
  
  let message: String?;
  let debug: String?;
  
  init(
    code: E,
    domain: String,
    message: String? = nil,
    debug: String? = nil
  ) {
    self.code = code;
    self.domain = domain;
    self.message = message;
    self.debug = debug;
  };
  
  func createJSONString() -> String? {
    let encoder = JSONEncoder();
    
    guard let data = try? encoder.encode(self),
          let jsonString = String(data: data, encoding: .utf8)
    else { return nil };
    
    return jsonString;
  };
};

extension RNIBaseError: Encodable {
  enum CodingKeys: String, CodingKey {
    case code, domain, message, debug;
  };
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self);
        
    try container.encode(self.code.rawValue, forKey: .code);
    try container.encode(self.domain, forKey: .domain);
    try container.encode(self.message, forKey: .message);
    try container.encode(self.debug, forKey: .debug);
  };
};

enum RNIGenericErrorCodes: String, Codable, CaseIterable {
  case runtimeError, libraryError, reactError, unknownError,
       invalidArgument, outOfBounds, invalidReactTag, nilValue;
};

typealias RNIGenericErrorCode = RNIBaseError<RNIGenericErrorCodes>;
