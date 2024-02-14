//
//  ClassRegistry.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation


public class ClassRegistry {

  public static var shouldCacheClasses = true;

  static var _allClasses: [AnyClass]?;

  public var allClasses: [AnyClass] {
    if Self.shouldCacheClasses,
       let _allClasses = Self._allClasses {
       
      return _allClasses;
    };
    
		let numberOfClasses = Int(objc_getClassList(nil, 0));
    guard numberOfClasses > 0 else { return [] };
    
    let classesPtr =
      UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses);
      
    let autoreleasingClasses =
      AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr);
    
    let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses));
    assert(numberOfClasses == count);
    
    defer {
      classesPtr.deallocate();
    };
    
    var classes: [AnyClass] = [];
    
    for index in 0 ..< numberOfClasses {
      classes.append(classesPtr[index]);
    };
    
    if Self.shouldCacheClasses {
      Self._allClasses = classes;
    };
    
    return classes;
	};
};

