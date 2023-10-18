//
//  RNIDefaultErrorCodes.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation

public protocol RNIDefaultErrorCodes {
  static var nilReactBridge             : Self { get };
  static var viewNotFoundForReactTag    : Self { get };
  static var unableToParseArguments     : Self { get };
  static var viewForReactTagTypeMismatch: Self { get };
};
