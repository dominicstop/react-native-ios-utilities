//
//  RNIDummyViewManager.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/5/23.
//

import Foundation
import DGSwiftUtilities


public let RNIDummyViewRegistry = RNIDummyViewRegistryManager.shared;

public final class RNIDummyViewRegistryManager {
  public static let shared: RNIDummyViewRegistryManager = .init();
  
  public var dummyViews: [WeakRef<RNIDummyView>] = [];
  
  public var detachedDummyViews = NSMapTable<NSNumber, RNIDummyView>.init(
    keyOptions: .copyIn,
    valueOptions: .strongMemory
  );
  
  func register(dummyView: RNIDummyView, shouldRetain: Bool){
    self.dummyViews.append(
      WeakRef(with: dummyView)
    );
    
    guard let reactTag = dummyView.reactTag else { return };
    
    if shouldRetain {
      self.detachedDummyViews.setObject(dummyView, forKey: reactTag);
    };
  };
  
  func remove(dummyView: RNIDummyView){
    self.dummyViews = self.dummyViews.filter {
      $0.ref != nil && $0.ref !== dummyView;
    };
  
    guard let reactTag = dummyView.reactTag else { return };
    self.detachedDummyViews.removeObject(forKey: reactTag);
  };
  
  func removeAll(belongingToParent parent: UIView){
    let enumerator = self.detachedDummyViews.objectEnumerator() ?? NSEnumerator();
    
    for object in enumerator {
      let dummyView = object as! RNIDummyView;
      let dummySuperview = dummyView.superview ?? dummyView.cachedSuperview;
      
      guard dummySuperview !== parent else { continue };
      self.detachedDummyViews.removeObject(forKey: dummySuperview?.reactTag);
    };
    
    self.dummyViews = self.dummyViews.filter {
      guard let dummyView = $0.ref else { return false };
      let dummySuperview = dummyView.superview ?? dummyView.cachedSuperview;
      
      return dummySuperview !== parent;
    };
  };
  
  func getInstance(forKey key: NSNumber) -> RNIDummyView? {
    if let dummyView = self.detachedDummyViews.object(forKey: key){
      return dummyView;
    };
  
    let match = self.dummyViews.first {
      $0.ref?.reactTag == key;
    };
    
    return match?.ref;
  };
  
  func getInstance(belongingTo parent: UIView) -> RNIDummyView? {
    let match = self.dummyViews.first {
      guard let dummyView = $0.ref else { return false };
      let parentView = dummyView.superview ?? dummyView.cachedSuperview;
      
      return parentView === parent;
    };
  
    return match?.ref;
  };
};
