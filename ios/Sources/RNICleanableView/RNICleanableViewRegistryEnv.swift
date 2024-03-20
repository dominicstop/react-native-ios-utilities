//
//  RNICleanableViewRegistryEnv.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation
import DGSwiftUtilities

public struct RNICleanableViewRegistryEnv {

  public static var shouldGloballyDisableCleanup = false;
  public static var shouldAllowForceCleanup = true;
  public static var shouldUseUIManagerQueueForCleanup = true;
  
  public static var shouldIncludeDelegateInViewsToCleanupByDefault = false;
  public static var shouldProceedCleanupWhenDelegateIsNilByDefault = true;
  
  public static var debugShouldLogCleanup = false;
  public static var debugShouldLogRegister = false;
  
  public static func updateEnv(usingDict dict: Dictionary<String, Any>) {
    if let value = try? dict.getValueFromDictionary(
      forKey: "shouldGloballyDisableCleanup",
      type: Bool.self
    ) {
      Self.shouldGloballyDisableCleanup = value;
    };
    
    if let value = try? dict.getValueFromDictionary(
      forKey: "shouldAllowForceCleanup",
      type: Bool.self
    ) {
      Self.shouldAllowForceCleanup = value;
    };
    
    if let value = try? dict.getValueFromDictionary(
      forKey: "shouldIncludeDelegateInViewsToCleanupByDefault",
      type: Bool.self
    ) {
      Self.shouldIncludeDelegateInViewsToCleanupByDefault = value;
    };
    
    if let value = try? dict.getValueFromDictionary(
      forKey: "shouldProceedCleanupWhenDelegateIsNilByDefault",
      type: Bool.self
    ) {
      Self.shouldProceedCleanupWhenDelegateIsNilByDefault = value;
    };
    
    if let value = try? dict.getValueFromDictionary(
      forKey: "debugShouldLogCleanup",
      type: Bool.self
    ) {
      Self.debugShouldLogCleanup = value;
    };
    
    if let value = try? dict.getValueFromDictionary(
      forKey: "debugShouldLogRegister",
      type: Bool.self
    ) {
      Self.debugShouldLogRegister = value;
    };
    
    if let value = try? dict.getValueFromDictionary(
      forKey: "shouldUseUIManagerQueueForCleanup",
      type: Bool.self
    ) {
      Self.shouldUseUIManagerQueueForCleanup = value;
    };
  };
};
