//
//  RNIDetachaedView.swift
//  ReactNativeIosUtilities
//
//  Created by Dominic Go on 10/4/23.
//

import UIKit
import React
import ExpoModulesCore
import DGSwiftUtilities


public class RNIDetachedView: ExpoView {

  public enum DetachState {
    case initial;
    case detaching;
    case detached;
  };
  
  public static var detachedView: [WeakRef<RNIDetachedView>] = [];

  // MARK: Properties
  // ----------------
  
  public weak var eventDelegate: RNIDetachedViewEventsNotifiable?;
  
  private(set) public var touchHandler: RCTTouchHandler?;
  private(set) public weak var cachedSuperview: UIView?;
  
  private(set) public var detachState: DetachState = .initial;
  
  private(set) public var didTriggerCleanup = false;
  
  private var _firstSubview: UIView?;
  public var contentView: UIView? {
    switch self.contentTargetMode {
      case .subview:
        return self._firstSubview;
        
      case .wrapper:
        return self;
    }
  };
  
  // MARK: Properties - Props
  // ------------------------
  
  var contentTargetMode: RNIDetachedViewContentTargetMode = .wrapper;
  public var contentTargetModeProp: String? {
    willSet {
      guard let newValue = newValue,
            let contentTargetMode =
              try? RNIDetachedViewContentTargetMode(fromString: newValue)
      else { return };
      
      self.contentTargetMode = contentTargetMode;
    }
  };
  
  public var shouldCleanupOnComponentWillUnmount = false;
  
  // MARK: Properties - Prop - Events
  // --------------------------------
  
  let onViewDidDetach = EventDispatcher("onViewDidDetach");
  
  // MARK: Init
  // ----------

  public required init(appContext: AppContext? = nil) {
    super.init(appContext: appContext);
  };
  
  // MARK: View-Lifecycle
  // --------------------
  
  public override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview);
    
    guard self.detachState != .detaching,
          let newSuperview = newSuperview,
          newSuperview !== self.cachedSuperview
    else { return };

    self.cachedSuperview = newSuperview;
  };
  
  public override func didMoveToSuperview() {
    super.didMoveToSuperview();
  };
  
  public override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow);
  };
  
  public override func didMoveToWindow() {
    super.didMoveToWindow();
  };
  
  public override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview);
  };
  
  public override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview);
  };
  
  public override func layoutSubviews() {
    super.layoutSubviews();
    self.eventDelegate?.notifyOnLayoutSubviews(sender: self);
  };
  
  // MARK: Functions
  // ---------------
  
  public func detach() throws {
    guard let bridge = self.appContext?.reactBridge else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `reactBridge` instance"
      );
    };
    
    let contentView: UIView = try {
      switch self.contentTargetMode {
        case .subview:
          guard let firstSubview = self.subviews.first else {
            throw RNIUtilitiesError(
              errorCode: .unexpectedNilValue,
              description: "Unable to get `contentView`"
            );
          };
          
          self._firstSubview = firstSubview;
          return firstSubview;
          
        case .wrapper:
          return self;
      }
    }();
    
    guard let touchHandler = RCTTouchHandler(bridge: bridge) else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to create `RCTTouchHandler` instance"
      );
    };
    
    self.detachState = .detaching;
    contentView.removeFromSuperview();
    
    touchHandler.attach(to: contentView);
    self.touchHandler = touchHandler;
    
    Self.detachedView.append(
      .init(with: self)
    );
    
    self.detachState = .detached;
    self.onViewDidDetach.callAsFunction([:]);
  };
  
  public func updateBounds(newSize: CGSize) throws {
    guard let reactBridge = self.appContext?.reactBridge else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get `reactBridge` instance"
      );
    };
    
    guard let contentView = self.contentView else {
      throw RNIUtilitiesError(
        errorCode: .unexpectedNilValue,
        description: "Unable to get contentView"
      );
    };
    
    reactBridge.uiManager.setSize(newSize, for: contentView);
  };
  
  // MARK: Module Functions
  // ----------------------
  
  public func notifyOnComponentWillUnmount(isManuallyTriggered: Bool){
    self.eventDelegate?.notifyOnJSComponentWillUnmount(
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

extension RNIDetachedView: RNICleanable {
  
  public func cleanup(){
    guard !self.didTriggerCleanup,
          let bridge = self.appContext?.reactBridge
    else { return };
    
    self.didTriggerCleanup = true;
    
    if let touchHandler = self.touchHandler,
       let contentView = self.contentView {
       
      touchHandler.detach(from: contentView);
    };
    
    RNIHelpers.recursivelyRemoveFromViewRegistry(
      forReactView: self.contentView ?? self,
      usingReactBridge: bridge
    );
    
    self.touchHandler = nil;
  };
};
