//
//  RNICleanableViewRegistry.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 2/10/24.
//

import UIKit
import React
import ExpoModulesCore
import DGSwiftUtilities


public let RNICleanableViewRegistryShared = RNICleanableViewRegistry.shared;

public final class RNICleanableViewRegistry {

  public static let shared: RNICleanableViewRegistry = .init();
  
  typealias CleanupQueueItem = (
    viewsToCleanup: [UIView],
    entry: RNICleanableViewItem,
    delegate: RNICleanableViewDelegate?
  );
  
  // MARK: - Properties
  // ------------------
  
  public var registry: Dictionary<Int, RNICleanableViewItem> = [:];
  
  weak var _bridge: RCTBridge?;
  
  var _cleanupQueue: [CleanupQueueItem] = [];
  
  var _isCleanupActive = false;
  var _shouldAbortNextCleanup = false;
  
  // MARK: - Functions
  // -----------------
  
  public init(){
    #if DEBUG
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(Self._onRCTBridgeWillReloadNotification(_:)),
      name: NSNotification.Name.RCTBridgeWillReload,
      object: nil
    );
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(Self._onRCTJavaScriptDidLoad(_:)),
      name: NSNotification.Name.RCTJavaScriptDidLoad,
      object: nil
    );
    #endif
  };
  
  public func register(
    forDelegate delegate: RNICleanableViewDelegate,
    initialViewsToCleanup initialViewsToCleanupRaw: [UIView] = [],
    shouldIncludeDelegateInViewsToCleanup: Bool =
      RNICleanableViewRegistryEnv.shouldIncludeDelegateInViewsToCleanupByDefault,
      
    shouldProceedCleanupWhenDelegateIsNil: Bool =
      RNICleanableViewRegistryEnv.shouldProceedCleanupWhenDelegateIsNilByDefault
  ) throws {
    
    guard let viewCleanupKey = delegate.viewCleanupKey else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `viewCleanupKey`"
      );
    };
    
    self._setBridgeIfNeeded(usingDelegate: delegate);
    
    var initialViewsToCleanup = initialViewsToCleanupRaw.map {
      WeakRef(with: $0);
    };
    
    if shouldIncludeDelegateInViewsToCleanup,
       let reactView = delegate as? RCTView {
       
      initialViewsToCleanup.append(
        .init(with: reactView)
      );
    };
    
    #if DEBUG
    if RNICleanableViewRegistryEnv.debugShouldLogRegister {
      print(
        "RNICleanableViewRegistry.register",
        "\n - delegate.viewCleanupKey:", viewCleanupKey,
        "\n - delegate type:", type(of: delegate),
        "\n - initialViewsToCleanup.count", initialViewsToCleanup.count,
        "\n - shouldIncludeDelegateInViewsToCleanup", shouldIncludeDelegateInViewsToCleanup,
        "\n - shouldProceedCleanupWhenDelegateIsNil", shouldProceedCleanupWhenDelegateIsNil,
        "\n"
      );
    };
    #endif
    
    self.registry[viewCleanupKey] = .init(
      key: viewCleanupKey,
      delegate: delegate,
      viewsToCleanup: initialViewsToCleanup,
      shouldProceedCleanupWhenDelegateIsNil: shouldProceedCleanupWhenDelegateIsNil,
      viewCleanupMode: delegate.viewCleanupMode
    );
  };
  
  func unregister(forKey key: Int){
    self.registry.removeValue(forKey: key);
  };

  func unregister(forDelegate delegate: RNICleanableViewDelegate) throws {
    let match: RNICleanableViewItem? = {
      if let viewCleanupKey = delegate.viewCleanupKey,
         let match = self.getEntry(forKey: viewCleanupKey) {
         
         return match;
      };
      
      return self.registry.values.first {
        $0.delegate === delegate;
      };
    }();
  
    guard let match = match else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get matching entry for delegate"
      );
    };
    
    self.unregister(forKey: match.key);
  };
  
  public func getEntry(forKey key: Int) -> RNICleanableViewItem? {
    return self.registry[key];
  };

  public func notifyCleanup(
    forKey key: Int,
    sender: RNICleanableViewSenderType,
    shouldForceCleanup: Bool,
    cleanupTrigger: RNIViewCleanupTrigger?
  ) throws {
  
    guard !RNICleanableViewRegistryEnv.shouldGloballyDisableCleanup else {
      throw RNIUtilitiesError(
        errorCode: .guardCheckFailed,
        description: "Cleanup is disabled via: shouldGloballyDisableCleanup",
        extraDebugValues: [
          "key": key,
          "sender": sender,
          "shouldForceCleanup": shouldForceCleanup,
        ]
      );
    };
    
    guard let match = self.getEntry(forKey: key) else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Could not get associated `RNICleanableViewItem` for key",
        extraDebugValues: [
          "key": key,
          "sender": sender,
          "shouldForceCleanup": shouldForceCleanup,
        ]
      );
    };
    
    guard !match._isQueuedForCleanup else { return };

    self._addToQueue(forEntry: match);
    
    guard !self._isCleanupActive else { return };
    
    if RNICleanableViewRegistryEnv.shouldUseUIManagerQueueForCleanup {
      guard let bridge = self._bridge else {
        throw RNIUtilitiesError(
          errorCode: .unexpectedNilValue,
          description: "Unable to get react bridge"
        );
      };
      
      RCTExecuteOnUIManagerQueue {
        bridge.uiManager?.addUIBlock { _,_ in
          #if DEBUG
          guard !self._shouldAbortNextCleanup else { return };
          #endif
        
          DispatchQueue.main.async {
            self._recursivelyDequeue(
              sender: sender,
              shouldForceCleanup: shouldForceCleanup,
              cleanupTrigger: cleanupTrigger
            );
          };
        };
      };
    } else {
      self._recursivelyDequeue(
        sender: sender,
        shouldForceCleanup: shouldForceCleanup,
        cleanupTrigger: cleanupTrigger
      );
    };
  };
  
  public func notifyCleanup(
    forDelegate delegate: RNICleanableViewDelegate,
    shouldForceCleanup: Bool,
    cleanupTrigger: RNIViewCleanupTrigger?
  ) throws {
  
    guard let viewCleanupKey = delegate.viewCleanupKey else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Could not get viewCleanupKey from delegate"
      );
    };
    
    try self.notifyCleanup(
      forKey: viewCleanupKey,
      sender: .cleanableViewDelegate(delegate),
      shouldForceCleanup: shouldForceCleanup,
      cleanupTrigger: cleanupTrigger
    );
  };
  
  // MARK: - Internal Functions
  // --------------------------
  
  #if DEBUG
  @objc func _onRCTBridgeWillReloadNotification(_ notification: Notification){
    self._cleanupQueue = [];
    self._shouldAbortNextCleanup = true;
  };
  
  @objc func _onRCTJavaScriptDidLoad(_ notification: Notification){
    self._isCleanupActive = false;
    self._shouldAbortNextCleanup = false;
  };
  #endif
  
  func _setBridgeIfNeeded(usingDelegate delegate: RNICleanableViewDelegate){
    guard self._bridge == nil else { return };
    
    // var window: UIWindow?;
    
    switch delegate {
      case let expoView as ExpoView:
        self._bridge = expoView.appContext?.reactBridge;
       // window = expoView.window;
        
      case let reactView as RCTView:
        self._bridge = reactView.closestParentRootView?.bridge;
        // window = reactView.window;
        
      // case let view as UIView:
      //   window = view.window;
        
      default:
        break;
    };
    
    // bridge is still nil, continue getting the bridge via other means...
    guard self._bridge == nil else { return };
    self._bridge = RNIHelpers.bridge;
  };
  
  func _addToQueue(forEntry entry: RNICleanableViewItem){
    entry._isQueuedForCleanup = true;
    
    var allViewsInCleanupQueue: [UIView] = [];
    
    self._cleanupQueue.forEach {
      allViewsInCleanupQueue += $0.viewsToCleanup;
    };
    
    var viewsToCleanup: [UIView] = [];
    var otherItemsToCleanup: [RNICleanableViewItem] = [];
    
    for weakView in entry.viewsToCleanup {
      guard let view = weakView.ref else { continue };
      
      let hasMatchA = viewsToCleanup.contains {
        view === $0;
      };
      
      let hasMatchB = otherItemsToCleanup.contains {
        view === $0.delegate;
      };
      
      let hasMatchC = allViewsInCleanupQueue.contains {
        view === $0;
      };
      
      let isDuplicate = hasMatchA || hasMatchB || hasMatchC;
      
      // skip duplicates
      guard !isDuplicate else { continue };
      
      if let cleanableView = view as? RNICleanableViewDelegate,
         let cleanableViewItem = cleanableView.associatedCleanableViewItem,
         cleanableViewItem.delegate !== view {
         
        otherItemsToCleanup.append(cleanableViewItem);
      
      } else if let reactView = view as? RCTView,
                let reactTag = reactView.reactTag,
                let entry = self.getEntry(forKey: reactTag.intValue),
                entry.delegate !== view {
                
        otherItemsToCleanup.append(entry);
      
      } else {
        viewsToCleanup.append(view);
      };
    };
    
    self._cleanupQueue.append((
      viewsToCleanup: viewsToCleanup,
      entry: entry,
      // temp. keeps a strong ref. to the delegate to prevent it from being
      // de-ref'd.
      delegate: entry.delegate
    ));
    
    for cleanupItem in otherItemsToCleanup {
      let hasMatch = self._cleanupQueue.contains {
           cleanupItem.key == $0.entry.key
        || cleanupItem.delegate === $0.delegate;
      };
      
      // skip duplicates
      guard !hasMatch else { continue };
      self._addToQueue(forEntry: cleanupItem);
    };
  };
  
  func _recursivelyDequeue(
    sender: RNICleanableViewSenderType,
    shouldForceCleanup: Bool,
    cleanupTrigger: RNIViewCleanupTrigger?,
    recursionCount: Int = 0
  ){
  
    let nextRecursionCount = recursionCount + 1;
  
    guard self._cleanupQueue.count > 0,
          let item = self._cleanupQueue.first
    else {
      self._isCleanupActive = false;
      return;
    };
    
    self._isCleanupActive = true;
    self._cleanupQueue.removeFirst();
        
    var shouldCleanup = false;
    
    if let delegate = item.delegate {
      shouldCleanup = delegate.notifyOnViewCleanupRequest(
        sender: sender,
        item: item.entry
      );
    
    } else if item.entry.shouldProceedCleanupWhenDelegateIsNil {
      shouldCleanup = true;
    };
    
    let shouldForceCleanup =
         shouldForceCleanup
      && RNICleanableViewRegistryEnv.shouldAllowForceCleanup;
    
    if shouldForceCleanup {
      shouldCleanup = true;
    };
    
    guard shouldCleanup else {
      #if DEBUG
      if RNICleanableViewRegistryEnv.debugShouldLogCleanup {
        let _className =
          (item.delegate as? NSObject)?.className ?? "N/A";
          
        let _viewReactTag =
          (item.delegate as? RCTView)?.reactTag?.intValue ?? -1;
        
        print(
          "RNICleanableViewRegistry._recursivelyDequeue",
          "\n - Failed to cleanup item...",
          "\n - key:", item.entry.key,
          "\n - delegate, type:", type(of: item.delegate),
          "\n - delegate, className:", _className,
          "\n - delegate, reactTag:", _viewReactTag,
          "\n - shouldProceedCleanupWhenDelegateIsNil:", item.entry.shouldProceedCleanupWhenDelegateIsNil,
          "\n - viewsToCleanup.count", item.entry.viewsToCleanup.count,
          "\n"
        );
      };
      #endif
    
      // re-add failed item to registry
      item.entry._isQueuedForCleanup = false;
      self.registry[item.entry.key] = item.entry;
    
      // proceed to next item...
      self._recursivelyDequeue(
        sender: sender,
        shouldForceCleanup: shouldForceCleanup,
        cleanupTrigger: cleanupTrigger,
        recursionCount: nextRecursionCount
      );
      return;
    };
    
    #if DEBUG
    if RNICleanableViewRegistryEnv.debugShouldLogCleanup {
      let _className = (item.delegate as? NSObject)?.className ?? "N/A";
      let _triggers = item.entry.viewCleanupMode.triggers.map { $0.rawValue; };
      
      print(
        "RNICleanableViewRegistry._recursivelyDequeue",
        "\n - forKey:", item.entry.key,
        "\n - cleanupTrigger:", cleanupTrigger?.rawValue ?? "N/A",
        "\n - match.viewsToCleanup.count:", item.entry.viewsToCleanup.count,
        "\n - match.shouldProceedCleanupWhenDelegateIsNil:", item.entry.shouldProceedCleanupWhenDelegateIsNil,
        "\n - match.delegate.className:", _className,
        "\n - match.viewCleanupMode.caseString:", item.entry.viewCleanupMode.caseString,
        "\n - match.viewCleanupMode.triggers:", _triggers,
        "\n - self._cleanupQueue.count:", self._cleanupQueue.count,
        "\n - recursionCount:", recursionCount,
        "\n"
      );
    };
    #endif
    
    item.delegate?.notifyOnViewCleanupWillBegin();
    item.entry.eventDelegates.invoke {
      $0.notifyOnViewCleanupWillBegin(
        forDelegate: item.delegate,
        registryEntry: item.entry
      );
    };
    
    try? self._cleanup(views: item.viewsToCleanup) {
      item.delegate?.notifyOnViewCleanupCompletion();
      
      // proceed to next item...
      self._recursivelyDequeue(
        sender: sender,
        shouldForceCleanup: shouldForceCleanup,
        cleanupTrigger: cleanupTrigger,
        recursionCount: nextRecursionCount
      );
    };
  };
  
  func _cleanup(
    views viewsToCleanup: [UIView],
    completion: (() -> Void)? = nil
  ) throws {
  
    guard let bridge = self._bridge else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get react bridge"
      );
    };
    
    RNIHelpers.recursivelyRemoveFromViewRegistry(
      forReactViews: viewsToCleanup,
      usingReactBridge: bridge
    ) {
      
      #if DEBUG
      if RNICleanableViewRegistryEnv.debugShouldLogCleanup {
        print(
          "RNICleanableViewRegistry._cleanup",
          "\n - viewsToCleanup.count:", viewsToCleanup.count,
          "\n"
        );
        
        viewsToCleanup.enumerated().forEach {
          print(
            "RNICleanableViewRegistry._cleanup",
            "\n - item: \($0.offset + 1) of \(viewsToCleanup.count)",
            "\n - reactTag:", $0.element.reactTag?.intValue ?? -1,
            "\n - className:", $0.element.className,
            "\n"
          );
        };
      };
      #endif
      
      completion?();
    };
  };
};
