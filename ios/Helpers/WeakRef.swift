//
//  WeakRef.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/5/23.
//

import Foundation

public struct WeakRef<T> where T: AnyObject {

  private(set) weak var value: T?;

  init(value: T?) {
    self.value = value;
  };
};
