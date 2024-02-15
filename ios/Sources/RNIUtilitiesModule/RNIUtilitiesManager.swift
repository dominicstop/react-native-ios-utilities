//
//  RNIUtilitiesManager.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation
import DGSwiftUtilities

public let RNIUtilitiesManagerShared = RNIUtilitiesManager.shared;

public class RNIUtilitiesManager {
  public static let shared: RNIUtilitiesManager = .init();
  
  public var sharedEnv: Dictionary<String, Any> = [:];
  
  public var eventDelegates =
    MulticastDelegate<RNIUtilitiesManagerEventsNotifiable>();
  
  init(){
    let singletonClasses =
      ClassRegistry.allClasses.getClasses(ofType: Singleton.Type.self);
      
    let delegateSingletonTypes = singletonClasses.compactMap {
      $0 as? RNIUtilitiesManagerEventsNotifiable.Type;
    };
    
    let delegateSingletons = delegateSingletonTypes.compactMap {
      $0.shared;
    };
    
    delegateSingletons.forEach {
      self.eventDelegates.add($0);
    };
  };
  
  func appendToSharedEnv(newEntries: Dictionary<String, Any>) {
    let oldSharedEnv = self.sharedEnv;
    let newSharedEnv = oldSharedEnv.merging(newEntries) { (_, new) in new };
    
    self.sharedEnv = newSharedEnv;
    
    self.eventDelegates.invoke {
      $0.notifyOnSharedEnvDidUpdate(
        sharedEnv: newSharedEnv,
        newEntries: newEntries,
        oldEntries: oldSharedEnv
      );
    };
  };
};
