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
    super.init();
    // call objc code testing
    
    let result = Utils.hexString(toColor: "#ff0000");
    print(
      "TestDummyClass.init - invoke Utils.hexString: \(String(describing: result))"
    );
  };

  @objc
  public func add(a: Int, b: Int) -> Int {
    return a+b;
  }
};
