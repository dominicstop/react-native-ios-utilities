//
//  RNIViewPropDelegate+AnyObject.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 8/26/24.
//

import Foundation



public extension RNIViewPropDelegate where Self: AnyObject {

  func setValue(
    withKeyPath keyPath: AnyKeyPath,
    value: Any?
  ){
    switch (keyPath, value) {
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, Bool>,
        let value as Bool
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, String>,
        let value as String
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, String?>,
        let value as String?
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, NSNumber>,
        let value as NSNumber
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, NSNumber?>,
        let value as NSNumber?
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, NSDictionary>,
        let value as NSDictionary
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, NSDictionary?>,
        let value as NSDictionary?
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, NSArray>,
        let value as NSArray
      ):
        self[keyPath: keyPath] = value;
        
      case (
        let keyPath as ReferenceWritableKeyPath<KeyPathRoot, NSArray?>,
        let value as NSArray?
      ):
        self[keyPath: keyPath] = value;
        
      default:
        break;
    };
  };
};
