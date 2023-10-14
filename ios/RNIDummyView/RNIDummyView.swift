//
//  RNIDummyView.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import ExpoModulesCore


public class RNIDummyView: ExpoView {

  // MARK: Properties
  // ----------------
  
  public weak var eventDelegate: RNIDummyViewEventsNotifiable?;
  private(set) public weak var cachedSuperview: UIView?;
  
  public var detachedViews: [UIView] = [];
  private(set) public var touchHandlers: Dictionary<NSNumber, RCTTouchHandler> = [:];
  
  private(set) public var didTriggerCleanup = false;
  
  // MARK: Properties - Props
  // ------------------------
  
  public var shouldCleanupOnComponentWillUnmount = false;
  
  // MARK: Init + Lifecycle
  // ----------------------

  public required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext);
    RNIDummyViewRegistry.register(dummyView: self, shouldRetain: false);
  };
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    
    if let superview = self.superview {
      self.cachedSuperview = superview;
    };
  };
  
  public override func insertReactSubview(_ subview: UIView!, at atIndex: Int) {
    subview.removeFromSuperview();
    self.detachedViews.append(subview);
  };
  
  // MARK: Functions
  // ---------------
  
  func registerAndDetach(){
    RNIDummyViewRegistry.register(dummyView: self, shouldRetain: true);
    self.removeFromSuperview();
  };
  
  // MARK: Module Functions
  // ----------------------
  
  func notifyOnComponentWillUnmount(isManuallyTriggered: Bool){
    self.eventDelegate?.onJSComponentWillUnmount(
      sender: self,
      isManuallyTriggered: isManuallyTriggered
    );
    
    if self.shouldCleanupOnComponentWillUnmount {
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.cleanup();
      };
    };
  };
};

// MARK: - RNICleanable
// --------------------

extension RNIDummyView: RNICleanable {
  
  public func cleanup(){
    guard !self.didTriggerCleanup,
          let bridge = self.appContext?.reactBridge
    else { return };
    
    self.didTriggerCleanup = true;
    let viewsToCleanup = self.detachedViews + [self];
 
    for view in viewsToCleanup  {
      if let touchHandler = self.touchHandlers[view.reactTag] {
        touchHandler.detach(from: view);
      };
      
      RNIHelpers.recursivelyRemoveFromViewRegistry(
        forReactView: view,
        usingReactBridge: bridge
      );
    };
    
    self.touchHandlers.removeAll();
    self.detachedViews.removeAll();
  };
};
