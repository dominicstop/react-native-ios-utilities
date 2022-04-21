//
//  RNIGenericError.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/21/22.
//

import Foundation


public class RNIGenericError: RNIBaseError<RNIGenericErrorCodes> {
  
  init(
    code: RNIGenericErrorCodes,
    message: String? = nil,
    debug: String? = nil
  ) {
    super.init(
      code: code,
      domain: "react-native-ios-utilities",
      message: message,
      debug: debug
    );
  };
};
