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

  public typealias Resolve = RNIModuleCommandRequestHandling.Resolve;
  
  public typealias Reject = RNIModuleCommandRequestHandling.Reject;
  
  public static let shared: RNIUtilitiesManager = .init();
  
  // MARK: - Properties
  // ------------------
  
  public var sharedEnv: Dictionary<String, Any> = [:];
  
  public var eventDelegates =
    MulticastDelegate<RNIUtilitiesManagerEventsNotifiable>();
    
  public var commandRequestDelegateMap =
    MappedMulticastDelegate<String, any RNIModuleCommandRequestHandling>();
  
  public var _debugBridgeReloadCounter = 0;
  
  // MARK: - Init + Setup
  // --------------------
  
  public override init(){
    super.init();
    self._setupRegisterEventDelegates();
    self._setupRegisterModuleRequestHandlers();
    
    #if DEBUG
    self._setupDebugObservers();
    #endif
  };
  
  func _setupRegisterEventDelegates(){
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
  
  func _setupRegisterModuleRequestHandlers(){
    let singletonClasses =
      ClassRegistry.allClasses.getClasses(ofType: Singleton.Type.self);
      
    let conformingSingletons: [
      any RNIModuleCommandRequestHandling
    ] = singletonClasses.compactMap {
    
      guard let delegateType = $0 as? any RNIModuleCommandRequestHandling.Type,
            delegateType != RNIUtilitiesManager.self
      else { return nil };
      
      return delegateType.shared;
    };
    
    conformingSingletons.forEach {
      self.commandRequestDelegateMap.add(
        forKey: type(of: $0).moduleName,
        withDelegate: $0
      );
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
  
  @objc(notifyForModuleCommandRequestForModuleName:commandName:withArguments:resolve:reject:)
  public func notifyForModuleCommandRequest(
    forModuleName moduleName: String,
    commandName: String,
    withArguments commandArgs: [String: Any],
    resolve resolveBlock: Resolve,
    reject rejectBlock: Reject
  ) {
    do {
      guard let moduleDelegate = self.commandRequestDelegateMap[moduleName] else {
        let commandRequestDelegates = self.commandRequestDelegateMap.allDelegates.map {
          "\($0.self)"
        };
        
        throw RNIUtilitiesError(
          errorCode: .unexpectedNilValue,
          description: "No associated module found for the provided `moduleName`",
          extraDebugValues: [
            "moduleName": moduleName,
            "commandName": commandName,
            "commandRequestDelegateMap": commandRequestDelegates,
            "commandRequestDelegateMap.delegateCount": self.commandRequestDelegateMap.delegateCount
          ]
        );
      };
      
      try moduleDelegate.invokePromiseCommand(
        named: commandName,
        withCommandArguments: commandArgs,
        resolve: resolveBlock
      );
      
    } catch {
      rejectBlock(error.localizedDescription);
    };
  };
};
