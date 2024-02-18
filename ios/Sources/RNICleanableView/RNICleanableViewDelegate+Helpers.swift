//
//  RNICleanableViewDelegate+Helpers.swift
//  ReactNativeIosContextMenu
//
//  Created by Dominic Go on 2/10/24.
//

import UIKit
import React
import DGSwiftUtilities


public extension RNICleanableViewDelegate {

  // MARK: - Computed Properties
  // ---------------------------

  var associatedCleanableViewItem: RNICleanableViewItem? {
    get {
      guard let viewCleanupKey = self.viewCleanupKey else { return nil };
      return RNICleanableViewRegistry.shared.getEntry(forKey: viewCleanupKey);
    }
  };
  
  var viewsToCleanup: Array<WeakRef<UIView>>? {
    self.associatedCleanableViewItem?.viewsToCleanup;
  };
  
  // MARK: - Functions
  // -----------------
  
  func cleanupOrphanedViews() throws {
    guard let cleanableViewItem = self.associatedCleanableViewItem else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Could not get associated cleanableViewItem",
        extraDebugValues: [
          "viewCleanupKey:": self.viewCleanupKey ?? -1
        ]
      );
    };
    
    let purged = cleanableViewItem.viewsToCleanup.compactMap {
      $0.ref;
    };
    
    let filtered = purged.filter {
      let isActive = $0.superview != nil && $0.window != nil;
      let isDelegate = $0 === cleanableViewItem.delegate
      
      return !isActive && !isDelegate;
    };
    
    var cleanableViewItems: [RNICleanableViewItem] = [];
    var viewsToClean: [UIView] = [];
    
    filtered.forEach {
      if let reactTag = $0.reactTag?.intValue,
         let match = RNICleanableViewRegistryShared.getEntry(forKey: reactTag) {
         
        cleanableViewItems.append(match);
        
      } else {
        viewsToClean.append($0);
      };
    };
    
    cleanableViewItems.forEach {
      try? RNICleanableViewRegistryShared.notifyCleanup(
        forKey: $0.key,
        sender: .cleanableViewDelegate(self),
        shouldForceCleanup: true,
        cleanupTrigger: nil
      );
    };
    
    try? RNICleanableViewRegistryShared._cleanup(views: viewsToClean)
  };
};
