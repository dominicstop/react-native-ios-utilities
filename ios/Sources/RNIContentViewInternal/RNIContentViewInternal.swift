//
//  RNIContentViewInternal.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/10/24.
//

import Foundation


public protocol RNIContentViewInternal: RNIContentView
  where Events: RNIViewInternalEvents {
    
  // empty requirements
};

// MARK: - RNIContentViewInternal+Helpers
// --------------------------------------

public extension RNIContentViewInternal {
  
  func dispatchRawNativeEvent(
    eventName: String,
    eventPayload: Dictionary<String, Any>,
    shouldPropagate: Bool
   ) throws {
   
    guard let parentReactView = self.parentReactView else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Could not get `parentReactView`"
      );
    };
      
    parentReactView.dispatchViewEvent(
      forEventName: eventName,
      withPayload: eventPayload
    );
  };
};

