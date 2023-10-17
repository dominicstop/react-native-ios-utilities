//
//  RNIUtilitiesError.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation


public typealias RNIUtilitiesError =
  RNIError<RNIUtilitiesErrorMetadata, RNIDefaultErrorCode>;

public struct RNIUtilitiesErrorMetadata: RNIErrorMetadata {
  public static var domain = "react-native-ios-utilities";
  
  public static var parentType: String? = nil;
};
