//
//  RNIUtilitiesError.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation
import DGSwiftUtilities


public struct RNIUtilitiesErrorMetadata: ErrorMetadata {
  public static var domain: String? = "react-native-ios-utilities";
  public static var parentType: String? = nil;
};

public typealias RNIUtilitiesError = RNIError<RNIUtilitiesErrorMetadata>;
