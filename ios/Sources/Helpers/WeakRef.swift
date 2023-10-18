//
//  WeakRef.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/5/23.
//

import Foundation

public struct WeakRef<T> where T: AnyObject {

  private(set) public weak var value: T?;

  public init(value: T?) {
    self.value = value;
  };
};
