//
//  RNIContentViewParentDelegate.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 4/30/24.
//

import UIKit
import DGSwiftUtilities

#if !RCT_NEW_ARCH_ENABLED
import React
#endif


#if RCT_NEW_ARCH_ENABLED
public typealias ReactView = UIView;
#else
public typealias ReactView = RCTView;
#endif

@objc(RNIContentViewParentDelegateSwift)
public protocol RNIContentViewParentDelegate where Self: ReactView {

  // MARK: Properties
  // ----------------
  
  var reactSubviewRegistry: NSMapTable<NSString, ReactView> { get };

  var cachedLayoutMetrics: RNILayoutMetrics? { get };
  
  var contentDelegate: RNIContentViewDelegate { get };
  
  var eventBroadcaster: RNIBaseViewEventBroadcaster! { get };
  
  var rawProps: NSDictionary { get };
  
  var viewID: String? { get };
  
  var intrinsicContentSizeOverride: CGSize { get set };
  
  // MARK: - Properties (Fabric Only)
  // -------------------------------
  
  #if RCT_NEW_ARCH_ENABLED
  var reactSubviews: [UIView] { get };
  #else
  
  // MARK: - Properties (Paper Only)
  // -------------------------------
  
  var cachedShadowView: RCTShadowView? { get };
  #endif
  
  // MARK: Methods
  // -------------
  
  func requestToRemoveReactSubview(_ subview: UIView);
  
  func setSize(_ size: CGSize);
  
  func dispatchViewEvent(
    forEventName eventName: String,
    withPayload payload: Dictionary<String, Any>
  );
  
  func attachReactTouchHandler();
  
  func detachReactTouchHandler();
  
  func reAttachCotentDelegate();
  
  // MARK: Methods (Fabric Only)
  // --------------------------
  
  #if RCT_NEW_ARCH_ENABLED
  func setPadding(_ insets: UIEdgeInsets);
  
  func setPositionType(_ positionType: RNILayoutMetrics.RNIPositionType);
  
  @objc
  func requestToUpdateState(_ nextState: RNIBaseViewState);
  #endif
};

// MARK: - RNIContentViewParentDelegate+PaperHelpers
// -------------------------------------------------

#if !RCT_NEW_ARCH_ENABLED
public extension RNIContentViewParentDelegate {
  
  var reactSubviews: [UIView] {
    self.reactSubviews();
  };
};
#endif

// MARK: - RNIContentViewParentDelegate+Helpers
// --------------------------------------------

public extension RNIContentViewParentDelegate {

  var viewLifecycleDelegates: MulticastDelegate<ViewLifecycleEventsNotifiable>! {
    self.eventBroadcaster.viewLifecycleDelegates;
  };
  
  var reactViewLifecycleDelegates: MulticastDelegate<RNIViewLifecycle>! {
    self.eventBroadcaster.reactViewLifecycleDelegates;
  };
  
  var reactViewPropUpdatesDelegates: MulticastDelegate<RNIViewPropUpdatesNotifiable> {
    self.eventBroadcaster.reactViewPropUpdatesDelegates;
  };
  
  var allReactSubviews: Array<ReactView> {
    let dict = self.reactSubviewRegistry.dictionaryRepresentation();
    return .init(dict.values);
  };
};
