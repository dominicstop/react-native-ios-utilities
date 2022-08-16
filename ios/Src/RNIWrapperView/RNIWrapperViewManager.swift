//
//  RNIWrapperViewManager.swift
//  IosNavigatorExample
//
//  Created by Dominic Go on 2/1/21.
//

import Foundation

@objc(RNIWrapperViewManager)
public class RNIWrapperViewManager: RCTViewManager {
  
  static var sharedBridge: RCTBridge?;
  
  // MARK: - RN Module Setup
  // -----------------------
  
  public override static func requiresMainQueueSetup() -> Bool {
    // run init in bg thread
    return false;
  };
  
  public override func view() -> UIView! {
    // save a ref to this module's RN bridge instance
    if Self.sharedBridge == nil {
      Self.sharedBridge = self.bridge;
    };
    
    return RNIWrapperView(bridge: self.bridge);
  };
  
  @objc func invalidate(){
    /// reset ref to RCTBridge instance
    Self.sharedBridge = nil;
  };
};

