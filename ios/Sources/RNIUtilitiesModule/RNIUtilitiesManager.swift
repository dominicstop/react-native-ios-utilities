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

  typealias DeferredActionBlock = (_ sender: RNIUtilitiesManager) -> Void;
  
  public static let shared: RNIUtilitiesManager = .init();
  
  // MARK: - Properties
  // ------------------
  
  private var state: LoadingState = .notLoaded;
  private var deferredActions: [DeferredActionBlock] = [];
  
  public var sharedEnv: Dictionary<String, Any> = [:];
  
  public var eventDelegates =
    MulticastDelegate<RNIUtilitiesManagerEventsNotifiable>();
  
  public var _debugBridgeReloadCounter = 0;
  
  // MARK: - Init + Setup
  // --------------------
  
  public init(){
    self.state = .loading;
    ClassRegistry.shared.loadClasses { sender, classes in
      self._setupRegisterDelegates(withClasses: classes);
    };
    
    #if DEBUG
    self._setupDebugObservers();
    #endif
  };
  
  // invoked on main thread, then runs in bg thread
  func _setupRegisterDelegates(withClasses classes: [AnyClass]){
    #if DEBUG
    print(
      "RNIUtilitiesManager._setupRegisterDelegates",
      "\n - allClasses count:", classes.count,
      "\n - Status: Load delegates begin",
      "\n"
    );
    #endif
  
    DispatchQueue.global(qos: .userInitiated).async {
      let singletonClasses = classes.getClasses(ofType: Singleton.Type.self);
      
      let delegateSingletons: [RNIUtilitiesManagerEventsNotifiable] = singletonClasses.compactMap {
        guard let delegateType = $0 as? RNIUtilitiesManagerEventsNotifiable.Type,
              delegateType != RNIUtilitiesManager.self
        else { return nil };
        
        return delegateType.shared;
      };
      
      DispatchQueue.main.async {
        #if DEBUG
        print(
          "RNIUtilitiesManager._setupRegisterDelegates",
          "\n - Status: Load delegates complete",
          "\n - singletonClasses count:", singletonClasses.count,
          "\n - RNIUtilitiesManager delegates count:", delegateSingletons.count,
          "\n"
        );
        #endif
        
        self._notifyOnSetupComplete(delegates: delegateSingletons);
      };
    };
  };
  
  // invoked in main thread, runs on main thread
  func _notifyOnSetupComplete(delegates: [RNIUtilitiesManagerEventsNotifiable]){
    delegates.forEach {
      self.eventDelegates.add($0);
    };
    
    self.eventDelegates.add(self);
    
    self.deferredActions.forEach {
      $0(self);
    };
    
    #if DEBUG
    print(
      "RNIUtilitiesManager._notifyOnSetupComplete",
      "\n - Status: Finalizing",
      "\n - deferredActions count:", deferredActions.count,
      "\n"
    );
    #endif
    
    self.deferredActions = [];
    self.state = .loaded;
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
  
  func notifyDelegates(
    block: @escaping (RNIUtilitiesManagerEventsNotifiable) -> Void
  ) {
    if self.state.isLoaded {
      block(self);
      return;
    };
    
    self.deferredActions.append { futureSelf in
      futureSelf.eventDelegates.invoke(block);
    };
  };
  
  func appendToSharedEnv(newEntries: Dictionary<String, Any>) {
    let oldSharedEnv = self.sharedEnv;
    let newSharedEnv = oldSharedEnv.merging(newEntries) { (_, new) in new };
    
    self.sharedEnv = newSharedEnv;
    
    #if DEBUG
    if !self.state.isLoaded {
      print(
        "RNIUtilitiesManager.appendToSharedEnv",
        "\n - Status: Scheduling...",
        "\n - newEntries:", newEntries,
        "\n"
      );
    };
    #endif
    
    self.notifyDelegates {
      $0.notifyOnSharedEnvDidUpdate(
        sharedEnv: newSharedEnv,
        newEntries: newEntries,
        oldEntries: oldSharedEnv
      );
      
      #if DEBUG
      if !self.state.isLoaded {
        print(
          "RNIUtilitiesManager.appendToSharedEnv",
          "\n - Status: Completed",
          "\n - newEntries:", newEntries,
          "\n - delegate:", $0,
          "\n"
        );
      };
      #endif
    };
  };
};
