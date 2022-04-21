//
//  RNIContainerViewControllerEventsDelegate.swift
//  react-native-ios-popover
//
//  Created by Dominic Go on 3/11/22.
//

import Foundation


@objc protocol RNIContainerViewControllerEventsDelegate {

  @objc optional func onViewControllerWillDisappear(
    sender: RNIContainerViewController,
    parentVC: UIViewController?,
    isBeingPopped: Bool
  );
  
  @objc optional func onViewControllerDidDisappear(
    sender: RNIContainerViewController,
    parentVC: UIViewController?,
    isBeingPopped: Bool
  );
  
};
