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
  
  public var touchHandler: RCTTouchHandler?;
  public weak var cachedSuperview: UIView?;
  
  public var detachState: DetachState = .initial;
  
  public var _didTriggerCleanup = false;
  
  private var _firstSubview: UIView?;
  public var contentView: UIView? {
    switch self.contentTargetMode {
      case .subview:
        return self._firstSubview;
        
      case .wrapper:
        return self;
    }
  };
  
  override public var reactTag: NSNumber! {
    didSet {
      try? RNICleanableViewRegistryShared.register(
        forDelegate: self,
        shouldIncludeDelegateInViewsToCleanup: true,
        shouldProceedCleanupWhenDelegateIsNil: true
      );
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
  
  private(set) public var viewCleanupMode: RNIViewCleanupMode = .default;
  public var internalViewCleanupModeRaw: Dictionary<String, Any>? {
    willSet {
      let nextValue: RNIViewCleanupMode = {
        guard let newValue = newValue,
              let viewCleanupMode = try? RNIViewCleanupMode(fromDict: newValue)
        else {
          return .default;
        };
        
        return viewCleanupMode;
      }();
      
      self.viewCleanupMode = nextValue;
      
      if let cleanableViewItem = self.associatedCleanableViewItem {
        cleanableViewItem.viewCleanupMode = nextValue;
      };
    }
  };
  
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
    
    guard self.detachState != .detaching else { return };
    
    // trigger manual cleanup, if needed
    try? self.viewCleanupMode.triggerCleanupIfNeededForDidMoveToWindow(
      forView: self,
      associatedViewController: nil,
      currentWindow: self.window
    );
  };
  
  public override func willRemoveSubview(_ subview: UIView) {
    super.willRemoveSubview(subview);
  };
  
  public override func didAddSubview(_ subview: UIView) {
    super.didAddSubview(subview);
    
    if let cleanableViewItem = self.associatedCleanableViewItem {
      cleanableViewItem.viewsToCleanup.append(
        .init(with: subview)
      );
      
      cleanableViewItem.viewsToCleanup += subview.recursivelyGetAllSubviews.map {
        .init(with: $0)
      };
    };
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
    self.removeFromSuperview();
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
};

// MARK: - RNICleanable
// --------------------

extension RNIDetachedView: RNICleanable {
  
  public func cleanup(){
    guard let viewCleanupKey = self.viewCleanupKey else { return };
    
    try? RNICleanableViewRegistryShared.notifyCleanup(
      forKey: viewCleanupKey,
      sender: .cleanableViewDelegate(self),
      shouldForceCleanup: true,
      cleanupTrigger: nil
    );
  };
};
