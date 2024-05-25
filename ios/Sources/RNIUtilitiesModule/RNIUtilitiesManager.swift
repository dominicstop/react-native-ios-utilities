//
//  RNIUtilitiesManager.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation
import DGSwiftUtilities


public let RNIUtilitiesManagerShared = RNIUtilitiesManager.shared;

@objc
public final class RNIUtilitiesManager: NSObject {
  
  public static let shared: RNIUtilitiesManager = .init();
  
  // MARK: - Properties
  // ------------------
  
  public var sharedEnv: Dictionary<String, Any> = [:];
  
  public var eventDelegates =
    MulticastDelegate<RNIUtilitiesManagerEventsNotifiable>();
  
  public var _debugBridgeReloadCounter = 0;
  
  // MARK: - Init + Setup
  // --------------------
  
  public init(){
    self._setupRegisterDelegates();
    
    #if DEBUG
    self._setupDebugObservers();
    #endif
  };
  
  func _setupRegisterDelegates(){
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
  
  #if DEBUG
  func _setupDebugObservers(){
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(Self._onRCTBridgeWillReloadNotification(_:)),
      name: NSNotification.Name.RCTBridgeWillReload,
      object: nil
    );
  };
  #endif
  
  #if DEBUG
  @objc func _onRCTBridgeWillReloadNotification(_ notification: Notification){
    self._debugBridgeReloadCounter += 1;
  };
  #endif
  
  // MARK: - Public Functions
  // ------------------------
  
  func _createBridgeReloadDidChangeBlock() -> (() -> Bool) {
    #if DEBUG
    let counterOld = self._debugBridgeReloadCounter;
    
    return {
      let counterNew = Self.shared._debugBridgeReloadCounter;
      return counterOld != counterNew;
    };
    #else
    return {
      return false
    };
    #endif
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
  
  // MARK: Visible in Obj-C
  // ----------------------
  
  @objc(shared)
  public static var sharedInstance: RNIUtilitiesManager {
    return Self.shared;
  };
};
