//
//  RNIDetachedViewContent.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

import UIKit
import DGSwiftUtilities


@objc(RNIDetachedViewContent)
public final class RNIDetachedViewContent: UIView, RNIContentView {

  // MARK: - Embedded Types
  // ----------------------
  
  public enum Events: String, CaseIterable {
    case onContentViewDidDetach;
  };
  
  // MARK: - Static Properties
  // -------------------------
  
  public static var propKeyPathMap:
    Dictionary<String, PartialKeyPath<RNIDetachedViewContent>> = [:];
  
  // MARK: - Properties - RNIContentViewDelegate
  // -------------------------------------------
  
  public weak var parentReactView: RNIContentViewParentDelegate?;
  
  // MARK: Properties - Props
  // ------------------------
  
  public var reactProps: NSDictionary = [:];

  // MARK: Init
  // ----------
  
  public override init(frame: CGRect) {
    super.init(frame: frame);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
};

// MARK: - RNIDetachedViewDelegate+RNIContentViewDelegate
// --------------------------------------------------

extension RNIDetachedViewContent: RNIContentViewDelegate {

  public typealias KeyPathRoot = RNIDetachedViewContent;

  // MARK: Paper + Fabric
  // --------------------
    
  public func notifyOnMountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
    #if !RCT_NEW_ARCH_ENABLED
    superBlock();
    #endif
    
    // Note: Window might not be available yet
    self.addSubview(childComponentView);
  };
  
  public func notifyOnUnmountChildComponentView(
    sender: RNIContentViewParentDelegate,
    childComponentView: UIView,
    index: NSInteger,
    superBlock: () -> Void
  ) {
    #if !RCT_NEW_ARCH_ENABLED
    superBlock();
    #endif
    
    childComponentView.removeFromSuperview();
  };
  
  public func notifyOnViewCommandRequest(
    sender: RNIContentViewParentDelegate,
    forCommandName commandName: String,
    withCommandArguments commandArguments: NSDictionary,
    resolve resolveBlock: (NSDictionary) -> Void,
    reject rejectBlock: (String) -> Void
  ) {
    
    do {
      guard let parentReactView = self.parentReactView else {
        throw RNIUtilitiesError(errorCode: .guardCheckFailed);
      };
      
      switch commandName {
        case "attachToWindow":
          guard let window = UIApplication.shared.activeWindow else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };
          
          self.translatesAutoresizingMaskIntoConstraints = false;
          window.addSubview(self);
          
          NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(
              equalTo: window.centerXAnchor
            ),
            self.centerYAnchor.constraint(
              equalTo: window.centerYAnchor
            ),
            self.widthAnchor.constraint(
              equalToConstant: 200
            ),
            self.heightAnchor.constraint(
              equalToConstant: 200
            ),
          ]);
          
          parentReactView.setSize(.init(width: 200, height: 200));
          resolveBlock([:]);
        
        default:
          throw RNIUtilitiesError(errorCode: .invalidValue);
      };
    
    } catch {
      rejectBlock(error.localizedDescription);
    };
  };
};
