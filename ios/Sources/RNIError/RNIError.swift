//
//  RNINavigatorError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation
import DGSwiftUtilities

public typealias RNIError<T: ErrorMetadata> =
  VerboseError<T, RNIDefaultErrorCode>;
