//
//  RNICleanableViewEventsNotifiable.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 2/15/24.
//

import Foundation


public protocol RNICleanableViewEventsNotifiable: AnyObject {
  
  func notifyOnViewCleanupWillBegin(
    forDelegate delegate: RNICleanableViewDelegate?,
    registryEntry cleanableViewItem: RNICleanableViewItem
  );
  
  func notifyOnViewCleanupCompletion(
    forDelegate delegate: RNICleanableViewDelegate?,
    registryEntry cleanableViewItem: RNICleanableViewItem
  );
};
