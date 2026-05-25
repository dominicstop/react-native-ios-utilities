//
//  RCTView+Helpers.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 11/2/23.
//

import Foundation
import React

public extension RCTView {
  
  var closestParentRootView: RCTRootView? {
    let targetType = RCTRootView.self;
  
    if let match = self.recursivelyFindParentView(whereType: targetType) {
      return match;
    };
    
    guard let rootView = self.rootViewForCurrentWindow else { return nil };
    
    if let reactRootView = rootView as? RCTRootView {
      return reactRootView;
    };
    
    return rootView.recursivelyFindSubview(whereType: targetType);
  };
  
  var closestParentReactContentView: RCTView? {
    guard let targetType = NSClassFromString("RCTRootContentView") else {
      return nil;
    };
  
    let parentMatch = self.recursivelyFindParentView(where: {
      $0.isKind(of: targetType);
    }) as? RCTView;

    if let parentMatch {
      return parentMatch;
    };
    
    guard let rootView = self.rootViewForCurrentWindow else { return nil };
    return rootView.recursivelyFindSubview(where: { $0.isKind(of: targetType) }) as? RCTView;
  };
  
  var reactTouchHandlers: [RCTTouchHandler]? {
    self.gestureRecognizers?.compactMap {
      $0 as? RCTTouchHandler
    };
  };
  
  var closestParentReactTouchHandler: RCTTouchHandler? {
    var currentView: UIView = self;
    
    while true {
      let reactTouchHandlers = currentView.gestureRecognizers?.compactMap {
        $0 as? RCTTouchHandler
      };
      
      if let match = reactTouchHandlers?.first {
        return match;
      };
      
      guard let superview = currentView.superview else { break };
      currentView = superview;
    };
    
    return closestParentReactContentView?.reactTouchHandlers?.first;
  };
};
