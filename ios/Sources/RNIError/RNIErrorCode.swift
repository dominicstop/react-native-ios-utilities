//
//  RNIErrorCode.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/18/23.
//

import Foundation

public protocol RNIErrorCode: RawRepresentable<String>, RNIDefaultErrorCodes  {
  var description: String { get };
};
