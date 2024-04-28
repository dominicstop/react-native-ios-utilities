//
//  TestDummyClass.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/28/24.
//

import Foundation

@objc
public class TestDummyClass: NSObject {

  public override init() {
    // no-op
  };

  @objc
  public func add(a: Int, b: Int) -> Int {
    return a+b;
  }
};
