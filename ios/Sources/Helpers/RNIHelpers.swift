//
//  RNIHelpers.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import React
import DGSwiftUtilities


public class RNIHelpers {

  public static var debugShouldLogViewRegistryEntryRemoval = false;
  
  public static var bridge: RCTBridge? {
    guard let keyWindow = UIApplication.shared.activeWindow,
          let rootVC = keyWindow.rootViewController,
          let rootView = rootVC.view,
          let rootReactView = rootView as? RCTRootView
    else {
      return nil;
    };
    
    return rootReactView.bridge;
  };
  
  static weak var _bridge: RCTBridge?;
  public static var cachedBridge: RCTBridge? {
    if let _bridge = Self._bridge {
      return _bridge;
    };
    
    let bridge = Self.bridge;
    Self._bridge = bridge;
    
    return bridge;
  };
  
  public static let osVersion = ProcessInfo().operatingSystemVersion;
  
  @discardableResult
  public static func recursivelyRemoveFromViewRegistry(
    forComponent component: RCTComponent,
    registry: NSMutableDictionary
  ) -> [NSNumber] {
  
    /// if this really is a "react view" then it should have a `reactTag`
    guard component.reactTag != nil,
          let reactTag = component.reactTag,
          reactTag.intValue > 0
    else { return [] };

    if let invalidatable = component as? RCTInvalidating {
      invalidatable.invalidate();
    };

    /// remove this "react view" from the registry
    registry.removeObject(forKey: reactTag);
    
    var removedReactViews: [NSNumber] = [reactTag];
    let reactSubviews = component.reactSubviews() ?? [];
    
    reactSubviews.forEach {
      removedReactViews += Self.recursivelyRemoveFromViewRegistry(
        forComponent: $0,
        registry: registry
      );
    };
    
    return removedReactViews;
  };
  
  /// If you remove a "react view" from the view hierarchy (e.g. via
  /// `removeFromSuperview`), it won't be released, because it's being retained
  /// by the `_viewRegistry` ivar in the shared `UIManager` (singleton)
  /// instance.
  ///
  /// The `_viewRegistry` keeps a ref. to all of the "react views" in the app.
  /// This explains how you can get a ref. to a view via `viewForReactTag` and
  /// `viewForNativeID`.
  ///
  /// If you are **absolutely sure** that a particular `reactView` is no longer
  /// being used, this helper func. will remove the specified `reactView` (and
  /// all of it's subviews) in the `_viewRegistry`.
  public static func recursivelyRemoveFromViewRegistry(
    forReactView reactView: UIView,
    usingReactBridge bridge: RCTBridge,
    completion: (() -> Void)? = nil
  ) {
  
    Self.recursivelyRemoveFromViewRegistry(
      forReactViews: [reactView],
      usingReactBridge: bridge,
      completion: completion
    );
  };
  
  public static func recursivelyRemoveFromViewRegistry(
    forReactViews reactViews: [UIView],
    usingReactBridge bridge: RCTBridge,
    completion: (() -> Void)? = nil
  ) {
  
    guard let uiManager = bridge.uiManager else {
      completion?();
      return;
    };
    
    let purgeChildrenSelector =
      NSSelectorFromString("_purgeChildren:fromRegistry:");
        
    let shouldInvokePurgeChildrenMethod =
      uiManager.responds(to: purgeChildrenSelector);
    
    RCTExecuteOnMainQueue {
      /// Get a ref to the `_viewRegistry` ivar in the `RCTUIManager` instance.
      let viewRegistry =
        uiManager.value(forKey: "_viewRegistry") as? NSMutableDictionary;
        
      guard let viewRegistry = viewRegistry else {
        completion?();
        return;
      };
      
      #if DEBUG
      if Self.debugShouldLogViewRegistryEntryRemoval {
        print(
          "RNIHelpers.recursivelyRemoveFromViewRegistry:",
          "\n - viewRegistry.count - before:", viewRegistry.count,
          "\n"
        );
      };
      #endif
      
      if shouldInvokePurgeChildrenMethod {
        uiManager.perform(
          purgeChildrenSelector,
          with: reactViews,
          with: viewRegistry
        );
        
      } else {
        reactViews.forEach {
          Self.recursivelyRemoveFromViewRegistry(
            forComponent: $0,
            registry: viewRegistry
          );
        };
      };
      
      reactViews.forEach {
        $0.removeFromSuperview();
      };
      
      #if DEBUG
      if Self.debugShouldLogViewRegistryEntryRemoval {
        print(
          "RNIHelpers.recursivelyRemoveFromViewRegistry:",
          "\n - viewRegistry.count - after:", viewRegistry.count,
          "\n"
        );
      };
      #endif
      
      RCTExecuteOnUIManagerQueue {
        /// Get a ref to the `_shadowViewRegistry` ivar in the `RCTUIManager`
        /// instance.
        let shadowViewRegistry =
          uiManager.value(forKey: "_shadowViewRegistry") as? NSMutableDictionary;
          
        guard let shadowViewRegistry = shadowViewRegistry else {
          completion?();
          return;
        };
        
        if shouldInvokePurgeChildrenMethod {
          uiManager.perform(
            purgeChildrenSelector,
            with: reactViews,
            with: shadowViewRegistry
          );
          
        } else {
          reactViews.forEach {
            Self.recursivelyRemoveFromViewRegistry(
              forComponent: $0,
              registry: shadowViewRegistry
            );
          };
        };
        
        DispatchQueue.main.async {
          completion?();
        };
      };
    };
  };
  
  
  /// Recursive climb the responder chain until `T` is found.
  /// Useful for finding the corresponding view controller of a view.
  /// 
  public static func getParent<T>(responder: UIResponder, type: T.Type) -> T? {
    var parentResponder: UIResponder? = responder;
    
    while parentResponder != nil {
      parentResponder = parentResponder?.next;
      
      if let parent = parentResponder as? T {
        return parent;
      };
    };
    
    return nil;
  };
  
  public static func getView<T>(
    forNode node: NSNumber,
    type: T.Type,
    bridge: RCTBridge?
  ) -> T? {
    guard let bridge = bridge,
          let view   = bridge.uiManager?.view(forReactTag: node)
    else { return nil };
    
    return view as? T;
  };
  
  public static func recursivelyGetAllSubviews(for view: UIView) -> [UIView] {
    var views: [UIView] = [];
    
    for subview in view.subviews {
      views += Self.recursivelyGetAllSubviews(for: subview);
      views.append(subview);
    };

    return views;
  };
  
  public static func recursivelyGetAllSuperViews(for view: UIView) -> [UIView] {
    var views: [UIView] = [];
    
    if let parentView = view.superview {
      views.append(parentView);
      views += Self.recursivelyGetAllSuperViews(for: parentView);
    };
    
    return views;
  };
  
  public static func compareImages(_ a: UIImage?, _ b: UIImage?) -> Bool {
    if (a == nil && b == nil){
      // both are nil, equal
      return true;
      
    } else if a == nil || b == nil {
      // one is nil, not equal
      return false;
      
    } else if a! === b! {
      // same ref to the object, true
      return true;
      
    } else if a!.size == b!.size {
      // size diff, not equal
      return true;
    };
    
    // compare raw data
    return a!.isEqual(b!);
  };
};
