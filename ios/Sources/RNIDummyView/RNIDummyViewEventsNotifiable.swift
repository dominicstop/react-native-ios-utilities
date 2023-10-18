//
//  RNIDummyViewEventsNotifiable.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 7/17/22.
//

import Foundation


public protocol RNIDummyViewEventsNotifiable: AnyObject {
  func onJSComponentWillUnmount(
    sender: RNIDummyView,
    isManuallyTriggered: Bool
  );
};
