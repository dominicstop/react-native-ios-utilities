//
//  UIApplication+Helpers.swift
//  
//
//  Created by Dominic Go on 9/27/23.
//

import UIKit


extension UIApplication {

  public var keyWindow: UIWindow? {
    guard #available(iOS 13.0, *) else {
      // Using iOS 12 and below
      return UIApplication.shared.windows.first;
    };
    
  // Get connected scenes
  return self.connectedScenes
    // Keep only active scenes, onscreen and visible to the user
    .filter { $0.activationState == .foregroundActive }
    // Keep only the first `UIWindowScene`
    .first(where: { $0 is UIWindowScene })
    // Get its associated windows
    .flatMap({ $0 as? UIWindowScene })?.windows
    // Finally, keep only the key window
    .first(where: \.isKeyWindow);
  };

  public var presentedViewControllerForKeyWindow: UIViewController? {
    var topVC = self.keyWindow?.rootViewController;

    // If root `UIViewController` is a `UITabBarController`
    if let presentedController = topVC as? UITabBarController {
      // Move to selected `UIViewController`
      topVC = presentedController.selectedViewController;
    };
      
    // Go deeper to find the last presented `UIViewController`
    while let presentedController = topVC?.presentedViewController {
      // If root `UIViewController` is a `UITabBarController`
      if let presentedController = presentedController as? UITabBarController {
        // Move to selected `UIViewController`
        topVC = presentedController.selectedViewController;
        
      } else {
        // Otherwise, go deeper
        topVC = presentedController;
      };
    };
    
    return topVC;
  };
};
