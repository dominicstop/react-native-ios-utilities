//
//  RNIGenericErrorCode.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/21/22.
//

import Foundation

public enum RNIGenericErrorCodes: String, Codable, CaseIterable {
  case runtimeError, libraryError, reactError, unknownError,
       invalidArgument, outOfBounds, invalidReactTag, nilValue;
};

public typealias RNIGenericErrorCode = RNIBaseError<RNIGenericErrorCodes>;
