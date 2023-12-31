//
//  CAGradientLayerType+CaseIterable.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 12/31/23.
//

import Foundation

extension CAGradientLayerType: CaseIterable {

  public static var allCases: [Self] = {
    var cases: [Self] = [
      .axial,
      .radial,
    ];
    
    if #available(iOS 12.0, *) {
      cases.append(.conic);
    };
    
    return cases;
  }();
};
