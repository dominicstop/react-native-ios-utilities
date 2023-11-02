//
//  RNIModuleHelpers.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import ExpoModulesCore
import DGSwiftUtilities

public class RNIModuleHelpers {
  
  public static func getReactBridge(
    withErrorType errorType: RNIError<some ErrorMetadata>.Type
  ) throws -> RCTBridge {
  
    guard let bridge = RNIHelpers.bridge else {
      throw errorType.init(errorCode: .nilReactBridge);
    };
    
    return bridge;
  };
  
  public static func getView<T>(
    withErrorType errorType: RNIError<some ErrorMetadata>.Type,
    forNode node: Int,
    type: T.Type,
    bridge: RCTBridge? = nil
  ) throws -> T {
    
    let bridge = try bridge ?? Self.getReactBridge(withErrorType: errorType);
    
    let debugValues: Dictionary<String, Any> = [
      "targetType": T.self,
      "node": node
    ];
  
    guard let rawView = bridge.uiManager?.view(forReactTag: node as NSNumber) else {
      throw errorType.init(
        errorCode: .viewNotFoundForReactTag,
        extraDebugValues: debugValues
      );
    };
    
    guard let view = rawView as? T else {
      throw errorType.init(
        errorCode: .viewForReactTagTypeMismatch,
        extraDebugValues: debugValues
      );
    };
    
    return view;
  };
};
