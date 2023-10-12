//
//  RNINavigatorError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation

public struct RNIError: LocalizedError {
  
  public var domain: String;
  public var description: String;
  public var extraDebugInfo: String?;

  public var fileName: String;
  public var lineNumber: Int;
  public var columnNumber: Int;
  public var functionName: String;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var debugTrace: String {
      "fileName: \(self.fileName)"
    + " - functionName: \(self.functionName)"
    + " - lineNumber: \(self.lineNumber)"
    + " - columnNumber: \(self.columnNumber)"
  };
  
  public var baseErrorMessage: String {
    var errorMessage =
        "domain: \(self.domain)"
      + " - description: \(self.description)";
  
    if let extraDebugInfo = self.extraDebugInfo {
      errorMessage += " - extraDebugInfo: \(extraDebugInfo)";
    };
    
    return errorMessage;
  };
  
  public var errorDescription: String? {
    self.baseErrorMessage + " - \(self.debugTrace)";
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    domain: String,
    description: String,
    extraDebugInfo: String,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function
  ) {
  
    self.domain = domain;
    self.description = description;
    self.extraDebugInfo = extraDebugInfo;
    
    self.fileName = fileName;
    self.lineNumber = lineNumber;
    self.columnNumber = columnNumber;
    self.functionName = functionName;
  };
};


open class RNIBaseError<E: RawRepresentable>: Error where E.RawValue == String  {
  
  public var code: E;
  public let domain: String;
  
  public let message: String?;
  public let debug: String?;
  
  public init(
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
  
  public func createJSONString() -> String? {
    let encoder = JSONEncoder();
    
    guard let data = try? encoder.encode(self),
          let jsonString = String(data: data, encoding: .utf8)
    else { return nil };
    
    return jsonString;
  };
};

// ----------------
// MARK:- Encodable
// ----------------

extension RNIBaseError: Encodable {
  enum CodingKeys: String, CodingKey {
    case code, domain, message, debug;
  };
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self);
        
    try container.encode(self.code.rawValue, forKey: .code);
    try container.encode(self.domain, forKey: .domain);
    try container.encode(self.message, forKey: .message);
    try container.encode(self.debug, forKey: .debug);
  };
};
