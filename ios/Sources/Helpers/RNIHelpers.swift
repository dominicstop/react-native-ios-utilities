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
  ///
  public static func recursivelyRemoveFromViewRegistry(
    forReactView reactView: UIView,
    usingReactBridge bridge: RCTBridge
  ) {
  
    guard let reactView = reactView as? RCTView else { return };
    
    /// Get a ref to the `_viewRegistry` ivar in the `RCTUIManager` instance.
    ///
    /// * Note: Unlike objc properties, ivars are "private" so they aren't
    ///   automagically exposed/bridged to swift.
    ///
    /// * Note: key is: `NSNumber` (the `reactTag`), and value: `UIView`
    ///
    let viewRegistry =
      bridge.uiManager?.value(forKey: "_viewRegistry") as? NSMutableDictionary;
    
    /// Get a ref to the `_shadowViewRegistry` ivar in the `RCTUIManager`
    /// instance.
    ///
    /// * Note: Execute on "RCT thread" (i.e. "com.facebook.react.ShadowQueue")
    ///
    let shadowViewRegistry =
      bridge.uiManager?.value(forKey: "_shadowViewRegistry") as? NSMutableDictionary;
    
    guard let viewRegistry = viewRegistry else { return };
    
    func removeView(_ v: UIView) -> [NSNumber] {
      /// if this really is a "react view" then it should have a `reactTag`
      guard v.reactTag != nil,
            let reactTag = v.reactTag,
            reactTag.intValue > 0,
            
            viewRegistry[reactTag] != nil
      else { return [] };
      
      /// remove this "react view" from the registry
      viewRegistry.removeObject(forKey: reactTag);
      
      /// remove from parent
      v.removeFromSuperview();
      
      let reactSubviews = v.subviews.compactMap {
        $0 as? RCTView;
      };
      
      var removedReactTags: [NSNumber] = [reactTag];
      reactSubviews.forEach {
        /// remove other subviews...
        removedReactTags += removeView($0);
      };
      
      return removedReactTags;
    };
    
    func removeShadowViews(for reactTags: [NSNumber]){
      guard let shadowViewRegistry = shadowViewRegistry else { return };
      
      reactTags.forEach {
        shadowViewRegistry.removeObject(forKey: $0);
      };
    };
    
    RCTExecuteOnMainQueue {
      // start recursively removing views...
      let removedReactTags = removeView(reactView);
      
      if Self.debugShouldLogViewRegistryEntryRemoval {
        #if DEBUG
        print(
          "RNIHelpers.recursivelyRemoveFromViewRegistry:",
          "\n - removedReactTags:", removedReactTags
        );
        #endif
      };
      
      // remove shadow views...
      RCTExecuteOnUIManagerQueue {
        removeShadowViews(for: removedReactTags);
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
