//
//  RNIDetachedViewContent.swift
//  react-native-ios-context-menu
//
//  Created by Dominic Go on 8/24/24.
//

import UIKit
import DGSwiftUtilities
import React


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
  
  // MARK: - Properties
  // ------------------
  
  public var didDetach = false;
  
  // MARK: - Properties - Props
  // --------------------------
  
  public var reactProps: NSDictionary = [:];

  // MARK: Init
  // ----------
  
  public override init(frame: CGRect) {
    super.init(frame: frame);
  };
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented");
  };
  
  // MARK: - Methods
  // ---------------
  
  func detach(){
    self.removeFromSuperview();
    self.didDetach = true;
    self.dispatchEvent(for: .onContentViewDidDetach, withPayload: [:]);
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
    #else
    childComponentView.removeFromSuperview();
    #endif
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
          
          
          let newSize: CGSize = .init(width: 200, height: 200);
          
          
          /// update size of view
          /// delay, attach to window
          /// result: ok
          ///
          func test01(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetachParent.requestToUpdateState(
              .init(
                shouldSetSize: true,
                frameSize: newSize
              )
            );
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              
              NSLayoutConstraint.activate([
                viewToDetach.centerXAnchor.constraint(
                  equalTo: window.centerXAnchor
                ),
                viewToDetach.centerYAnchor.constraint(
                  equalTo: window.centerYAnchor
                ),
                viewToDetach.widthAnchor.constraint(
                  equalToConstant: newSize.width
                ),
                viewToDetach.heightAnchor.constraint(
                  equalToConstant: newSize.height
                ),
              ]);
            };
          };
          
          /// attach to window
          /// delay, update size of view
          /// result: no
          ///
          func test02(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              
              NSLayoutConstraint.activate([
                viewToDetach.centerXAnchor.constraint(
                  equalTo: window.centerXAnchor
                ),
                viewToDetach.centerYAnchor.constraint(
                  equalTo: window.centerYAnchor
                ),
                viewToDetach.widthAnchor.constraint(
                  equalToConstant: newSize.width
                ),
                viewToDetach.heightAnchor.constraint(
                  equalToConstant: newSize.height
                ),
              ]);
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
              viewToDetachParent.requestToUpdateState(
                .init(
                  shouldSetSize: true,
                  frameSize: newSize
                )
              );
            };
          };
        
          /// update size of view + position absolute
          /// delay, attach to window
          /// result: ok, same as `test01`
          ///
          func test03(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetachParent.requestToUpdateState(
              .init(
                shouldSetSize: true,
                frameSize: newSize,
                shouldSetPositionType: true,
                positionType: .absolute
              )
            );
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              
              NSLayoutConstraint.activate([
                viewToDetach.centerXAnchor.constraint(
                  equalTo: window.centerXAnchor
                ),
                viewToDetach.centerYAnchor.constraint(
                  equalTo: window.centerYAnchor
                ),
                viewToDetach.widthAnchor.constraint(
                  equalToConstant: newSize.width
                ),
                viewToDetach.heightAnchor.constraint(
                  equalToConstant: newSize.height
                ),
              ]);
            };
          };
          
          
          /// update size of view
          /// delay, attach to window
          /// delay, update size of view
          /// delay, re-attach to window
          /// result: ok, when resizing constraints need to be adj again
          ///
          func test04(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetachParent.requestToUpdateState(
              .init(
                shouldSetSize: true,
                frameSize: newSize
              )
            );
            
            let widthConstraint = viewToDetach.widthAnchor.constraint(
              equalToConstant: newSize.width
            );
            
            let heightConstraint = viewToDetach.heightAnchor.constraint(
              equalToConstant: newSize.height
            );
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              
              NSLayoutConstraint.activate([
                viewToDetach.centerXAnchor.constraint(
                  equalTo: window.centerXAnchor
                ),
                viewToDetach.centerYAnchor.constraint(
                  equalTo: window.centerYAnchor
                ),
                widthConstraint,
                heightConstraint,
              ]);
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4){
              let newSize2: CGSize = .init(width: 300, height: 300);
              
              widthConstraint.constant = newSize2.width;
              heightConstraint.constant = newSize2.height;
              
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
              
              viewToDetachParent.requestToUpdateState(
                .init(
                  shouldSetSize: true,
                  frameSize: newSize2
                )
              );
              
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6){
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              
              NSLayoutConstraint.activate([
                viewToDetach.centerXAnchor.constraint(
                  equalTo: window.centerXAnchor
                ),
                viewToDetach.centerYAnchor.constraint(
                  equalTo: window.centerYAnchor
                ),
                widthConstraint,
                heightConstraint,
              ]);
            };
            
          };
          
          /// update size of view
          /// delay, attach to window
          /// delay, update size of view
          /// delay, re-activate constraints
          /// result: no - position updates, but not centered
          ///
          func test05(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetachParent.requestToUpdateState(
              .init(
                shouldSetSize: true,
                frameSize: newSize
              )
            );
            
            let widthConstraint = viewToDetach.widthAnchor.constraint(
              equalToConstant: newSize.width
            );
            
            let heightConstraint = viewToDetach.heightAnchor.constraint(
              equalToConstant: newSize.height
            );
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              
              NSLayoutConstraint.activate([
                viewToDetach.centerXAnchor.constraint(
                  equalTo: window.centerXAnchor
                ),
                viewToDetach.centerYAnchor.constraint(
                  equalTo: window.centerYAnchor
                ),
                widthConstraint,
                heightConstraint,
              ]);
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4){
              let newSize2: CGSize = .init(width: 300, height: 300);
              
              widthConstraint.constant = newSize2.width;
              heightConstraint.constant = newSize2.height;
              
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
              
              viewToDetachParent.requestToUpdateState(
                .init(
                  shouldSetSize: true,
                  frameSize: newSize2
                )
              );
              
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6){
              viewToDetach.constraints.forEach {
                $0.priority -= 1;
                $0.isActive = false;
              };
              
              viewToDetach.constraints.forEach {
                $0.isActive = true;
              };
              
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
            };
          };
          
          /// wrap react view in VC
          /// update size in `viewDidLayoutSubviews`
          /// result: ok - centered, fills entire screen
          ///
          ///
          func test06(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            class WrapperViewController: UIViewController {
              
              weak var contentParent: RNIContentViewParentDelegate!;
              weak var content: UIView!;
            
              override func viewDidLoad() {
                self.content.translatesAutoresizingMaskIntoConstraints = false;
                self.view.addSubview(content);
                
                NSLayoutConstraint.activate([
                  self.content.leadingAnchor.constraint(
                    equalTo: self.view.leadingAnchor
                  ),
                  self.content.trailingAnchor.constraint(
                    equalTo: self.view.trailingAnchor
                  ),
                  self.content.topAnchor.constraint(
                    equalTo: self.view.topAnchor
                  ),
                  self.content.bottomAnchor.constraint(
                    equalTo: self.view.bottomAnchor
                  ),
                ]);
              };
              
              override func viewDidLayoutSubviews() {
                self.contentParent.requestToUpdateState(
                  .init(
                    shouldSetSize: true,
                    frameSize: self.view.bounds.size
                  )
                );
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            childVC.contentParent = viewToDetachParent;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          
          
          test06();
          
          // self.detach();
          
          // viewToDetach.bounds.origin = .zero;
          
          
          
          
          
          // viewToDetachParent.setSize(newSize);
          // viewToDetachParent.frame.size = .init(width: 200, height: 200);
          
          // sender.setPositionType(.absolute);
          // sender.removeFromSuperview();
          // viewToDetachParent.setPositionType(.absolute);
          
          // RCTBridge.current().uiManager!.setSize(newSize, for: viewToDetach)
          
          
          resolveBlock([:]);
          
        case "presentInModal":
          let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
          let viewToDetach = viewToDetachParent.contentDelegate;
          
          class WrapperViewController: UIViewController {
            
            weak var contentParent: RNIContentViewParentDelegate!;
            weak var content: UIView!;
          
            override func viewDidLoad() {
              self.content.translatesAutoresizingMaskIntoConstraints = false;
              self.view.addSubview(content);
              
              NSLayoutConstraint.activate([
                self.content.leadingAnchor.constraint(
                  equalTo: self.view.leadingAnchor
                ),
                self.content.trailingAnchor.constraint(
                  equalTo: self.view.trailingAnchor
                ),
                self.content.topAnchor.constraint(
                  equalTo: self.view.topAnchor
                ),
                self.content.bottomAnchor.constraint(
                  equalTo: self.view.bottomAnchor
                ),
              ]);
            };
            
            override func viewDidLayoutSubviews() {
              self.contentParent.requestToUpdateState(
                .init(
                  shouldSetSize: true,
                  frameSize: self.view.bounds.size
                )
              );
            };
          };
          
          let modalVC = WrapperViewController();
          modalVC.content = viewToDetach;
          modalVC.contentParent = viewToDetachParent;
          
          
          let window = UIApplication.shared.activeWindow!;
          let rootVC = window.rootViewController!;
          rootVC.present(modalVC, animated: true);
          
          resolveBlock([:]);
        
        default:
          throw RNIUtilitiesError(errorCode: .invalidValue);
      };
    
    } catch {
      rejectBlock(error.localizedDescription);
    };
  };
  
  public func notifyOnPrepareForReuse(sender: RNIContentViewParentDelegate) {
    
  };
  
  // MARK: Paper Only
  // ----------------
  
  #if !RCT_NEW_ARCH_ENABLED
  public func notifyOnViewWillInvalidate(sender: RNIContentViewParentDelegate) {
    sender.reactSubviews.forEach {
      $0.removeFromSuperview();
    };
  };
  #endif
  
};
