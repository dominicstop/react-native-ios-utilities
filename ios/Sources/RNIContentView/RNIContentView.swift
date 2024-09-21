//
//  RNIContentView.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 5/13/24.
//

import Foundation
import DGSwiftUtilities


public protocol RNIContentView:
  RNIViewLifecycle, RNIViewPropUpdatesNotifiable, RNIViewPropHandling
    where Self: RNIContentViewDelegate & StringKeyPathMapping
{
  var horizontalAlignment: HorizontalAlignmentPosition { get };
  var verticalAlignment: VerticalAlignmentPosition { get }
};
