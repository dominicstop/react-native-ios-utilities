//
//  RNIImageCacheAndLoadingConfig.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 9/27/22.
//

import Foundation


@available(*, deprecated, message: "Use `ImageConfig` instead")
public protocol RNIImageLoadingConfigurable {
  var shouldCache: Bool? { get };
  var shouldLazyLoad: Bool? { get };
};

// TODO: Per file defaults via extension
@available(*, deprecated, message: "Use `ImageConfig` instead")
public struct RNIImageLoadingConfig: RNIImageLoadingConfigurable {

  public let shouldCache: Bool?;
  public let shouldLazyLoad: Bool?;
  
  public init(dict: Dictionary<String, Any>) {
    self.shouldCache = dict["shouldCache"] as? Bool;
    self.shouldLazyLoad = dict["shouldLazyLoad"] as? Bool;
  };
};
