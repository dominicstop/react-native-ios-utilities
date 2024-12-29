//
//  RNINativeViewIdentifier.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/29/24.
//

import Foundation
import DGSwiftUtilities

// #if !RCT_NEW_ARCH_ENABLED
import React

public enum RNINativeViewIdentifier {
  case reactTag(Int);
  case viewID(String);
  
  // MARK: - Functions
  // -----------------
  
  public func getAssociatedView() -> UIView? {
    switch self {
      case let .reactTag(reactTag):
        var match: UIView?;
        
        match = RNIViewRegistryShared.getViewForReactTag(
          .init(integerLiteral: reactTag)
        );
        
        if let match = match {
          return match;
        };
      
        let reactBridge = RCTBridge.current()!;
        match = reactBridge.uiManager!.view(
          forReactTag: .init(integerLiteral: reactTag)
        );
        
        return match;
        
      case let .viewID(viewID):
        return RNIViewRegistryShared.getViewForViewID(viewID);
    };
  };
};

// MARK: - RNINativeViewIdentifier+EnumCaseStringRepresentable
// -----------------------------------------------------------

extension RNINativeViewIdentifier: EnumCaseStringRepresentable {

  public var caseString: String {
    switch self {
      case .reactTag:
        return "reactTag";
        
      case .viewID:
        return "viewID";
    };
  };
};

// MARK: - RNINativeViewIdentifier+InitializableFromDictionary
// -----------------------------------------------------------

extension RNINativeViewIdentifier: InitializableFromDictionary {

  public init(fromDict dict: Dictionary<String, Any>) throws {
    if let viewID = try? dict.getString(forKey: "viewID") {
      self = .viewID(viewID);
      return;
    };
    
    if let reactTag = try? dict.getValue(
      forKey: "reactTag",
      type: Int.self
    ) {
      self = .reactTag(reactTag);
      return;
    };
    
    throw RNIUtilitiesError(
      errorCode: .invalidValue,
      description: "Could not get viewID or reactTag",
      extraDebugValues: dict
    );
  };
};
