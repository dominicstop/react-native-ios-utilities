//
//  RNINavigatorError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation


public struct RNIError<
  ErrorMetadata: RNIErrorMetadata,
  ErrorCodeEnum: RNIErrorCode
>: LocalizedError {

  public var errorCode: ErrorCodeEnum?;
  public var description: String;
  
  public var extraDebugValues: Dictionary<String, Any>?;
  public var extraDebugInfo: String?;

  public var fileName: String;
  public var lineNumber: Int;
  public var columnNumber: Int;
  public var functionName: String;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var debugTrace: String {
    var string = "fileName: \(self.fileName)";
    
    if let parentType = ErrorMetadata.parentType {
      string += " - type: \(parentType)";
    };
    
    string += " - functionName: \(self.functionName)";
    string += " - lineNumber: \(self.lineNumber)";
    string += " - columnNumber: \(self.columnNumber)";
    
    return string;
  };
  
  var extraDebugValuesString: String? {
    guard let extraDebugValues = self.extraDebugValues else { return nil };
    
    let shouldIncludeOffset = extraDebugValues.count > 1;
  
    let items = extraDebugValues.enumerated().map {
      var string = "\($0.element.key): \($0.element.value)";
      
      let isLastItem = ($0.offset == extraDebugValues.count - 1);
      string += isLastItem ? "" : ", ";
      
      return string;
    };
    
    let itemsString = items.reduce("") {
      $0 + $1;
    };
    
    return "extraDebugValuesString: { \(itemsString) }";
  };
  
  public var baseErrorMessage: String {
    var errorMessage = "domain: \(ErrorMetadata.domain)";
      
    if let errorCode = self.errorCode {
      errorMessage += " - code: \(errorCode.rawValue)";
    };
    
    errorMessage += " - description: \(self.description)";
  
    if let extraDebugInfo = self.extraDebugInfo {
      errorMessage += " - extraDebugInfo: \(extraDebugInfo)";
    };
    
    if let extraDebugValuesString = self.extraDebugValuesString {
      errorMessage += " - extraDebugValues: \(extraDebugValuesString)";
    };
    
    return errorMessage;
  };
  
  public var errorDescription: String? {
    "\(self.baseErrorMessage) - \(self.debugTrace)";
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    description: String,
    extraDebugValues: Dictionary<String, Any>? = nil,
    extraDebugInfo: String? = nil,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function
  ) {
  
    self.description = description;
    
    self.extraDebugValues = extraDebugValues;
    self.extraDebugInfo = extraDebugInfo;
    
    self.fileName = fileName;
    self.lineNumber = lineNumber;
    self.columnNumber = columnNumber;
    self.functionName = functionName;
  };
  
  public init(
    errorCode: ErrorCodeEnum,
    description: String? = nil,
    extraDebugValues: Dictionary<String, Any>? = nil,
    extraDebugInfo: String? = nil,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function
  ) {
    
    self.errorCode = errorCode;
    self.description = description ?? errorCode.description;
    
    self.extraDebugValues = extraDebugValues;
    self.extraDebugInfo = extraDebugInfo;
    
    self.fileName = fileName;
    self.lineNumber = lineNumber;
    self.columnNumber = columnNumber;
    self.functionName = functionName;
  };
  
  // MARK: - Functions
  // -----------------
  
  func log(){
    #if DEBUG
    guard let errorDescription = self.errorDescription else { return };
    print("Error -", errorDescription);
    #endif
  };
};
