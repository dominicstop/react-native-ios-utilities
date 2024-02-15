//
//  RNICleanableViewRegistryEnv.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation
import DGSwiftUtilities

public struct RNICleanableViewRegistryEnv {
  public var shouldGloballyDisableCleanup: Bool;
  public var debugShouldLogCleanup: Bool;
  public var debugShouldLogRegister: Bool;
};

extension RNICleanableViewRegistryEnv: InitializableFromDictionary {
  public init(fromDict dict: Dictionary<String, Any>) throws {
  
    self.shouldGloballyDisableCleanup = {
      let value = try? dict.getValueFromDictionary(
        forKey: "shouldGloballyDisableCleanup",
        type: Bool.self
      );
      
      return value ?? false;
    }();
      
    self.debugShouldLogCleanup = {
      let value = try? dict.getValueFromDictionary(
        forKey: "debugShouldLogCleanup",
        type: Bool.self
      );
      
      return value ?? false;
    }();
      
    self.debugShouldLogRegister = {
      let value = try? dict.getValueFromDictionary(
        forKey: "debugShouldLogRegister",
        type: Bool.self
      );
      
      return value ?? false;
    }();
  };
};
