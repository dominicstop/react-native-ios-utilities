//
//  RNIUtilitiesManager.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation
import DGSwiftUtilities

public let RNIUtilitiesManagerShared = RNIUtilitiesManager.shared;

public final class RNIUtilitiesManager {
  
  public static let shared: RNIUtilitiesManager = .init();
  
  public var sharedEnv: Dictionary<String, Any> = [:];
  
  public var eventDelegates =
    MulticastDelegate<RNIUtilitiesManagerEventsNotifiable>();
  
  public init(){
    let singletonClasses =
      ClassRegistry.allClasses.getClasses(ofType: Singleton.Type.self);
      
    let delegateSingletons: [RNIUtilitiesManagerEventsNotifiable] = singletonClasses.compactMap {
      guard let delegateType = $0 as? RNIUtilitiesManagerEventsNotifiable.Type,
            delegateType != RNIUtilitiesManager.self
      else { return nil };
      
      return delegateType.shared;
    };
    
    delegateSingletons.forEach {
      self.eventDelegates.add($0);
    };
    
    self.eventDelegates.add(self);
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
