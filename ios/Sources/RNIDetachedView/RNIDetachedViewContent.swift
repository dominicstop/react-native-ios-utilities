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
  public var viewToDetach: RNIContentViewParentDelegate?;
  
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
  
  func detach() throws {
    guard !self.didDetach else {
      throw RNIUtilitiesError(errorCode: .illegalState);
    };
    
    guard let parentReactView = self.parentReactView else {
      throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
    };
    
    guard let viewToDetach = self.viewToDetach else {
      throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
    };
    
    #if RCT_NEW_ARCH_ENABLED
    parentReactView.setPositionType(.absolute);
    parentReactView.backgroundColor = .clear;
    parentReactView.alpha = 0.01;
    #else
    
    parentReactView.removeFromSuperview();
    #endif
    
    viewToDetach.attachReactTouchHandler();
    
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
  
    self.addSubview(childComponentView);
    
    if let viewToDetach = childComponentView as? RNIContentViewParentDelegate {
      self.viewToDetach = viewToDetach;
    };
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
      guard let parentReactView = self.parentReactView,
            let commandArguments = commandArguments as? Dictionary<String, Any>
      else {
        throw RNIUtilitiesError(errorCode: .guardCheckFailed);
      };
      
      switch commandName {
        case "attachToWindow":
          guard let window = UIApplication.shared.activeWindow else {
            throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
          };
          
          let contentPositionConfig: AlignmentPositionConfig = try {
            let dictConfig = try commandArguments.getValueFromDictionary(
              forKey: "contentPositionConfig",
              type: Dictionary<String, Any>.self
            );
            
            return try .init(fromDict: dictConfig);
          }();
          
          let newSize: CGSize = .init(width: 200, height: 200);
          
          
          #if RCT_NEW_ARCH_ENABLED
          /// Fabric
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
          
          /// Fabric
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
        
          /// Fabric
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
          
          /// Fabric
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
          
          /// Fabric
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
          
          /// Fabric
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
          
          /// Fabric
          /// Base: Test06
          /// wrap react view in VC
          /// update size in `viewDidLayoutSubviews`
          /// Use RNIWrapperView child as detached view
          /// result: Ok, Same as `Test06`
          ///
          func test07(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
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
          
          /// Fabric
          /// Base: Test06
          /// wrap react view in VC
          /// update size in `viewDidLayoutSubviews`
          /// Use content as detached view
          /// result:
          /// * stretches but size of `RNIDetachedNativeView` is
          ///   slightly wrong, too big.
          ///
          /// * Reload causes crash in `SurfaceHandler::stop`
          ///
          func test08(){
            let viewToDetachParent = sender;
            let viewToDetach = viewToDetachParent;
            
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
          #endif
          
          #if !RCT_NEW_ARCH_ENABLED
          /// Paper
          /// Base: test01
          ///
          /// update size of view
          /// delay, attach content to window
          ///
          /// result:
          /// * View did not detach
          /// * View did resize
          ///
          func test09(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetachParent.setSize(newSize);
            
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
          
          /// Paper
          /// Base: test01, test09
          ///
          /// update size of view
          /// attach content to window
          ///
          /// result: wrong
          /// * Same as `test09`
          /// * View did not detach
          /// * View did resize
          ///
          func test10(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent.contentDelegate;
            
            viewToDetachParent.setSize(newSize);
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
          
          /// Paper
          /// Base: test01, test10
          ///
          /// update size of view
          /// attach parent content to window
          ///
          /// result: wrong
          /// * View did detach
          /// * View did resize
          /// * View not centered, attached to top left
          ///
          func test11(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            viewToDetachParent.setSize(newSize);
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
          
          /// Paper
          /// Base: test01, test11
          ///
          /// remove from superview
          /// update size of view
          /// attach parent content to window
          ///
          /// result: wrong
          /// * Same results as: `test11`
          /// * View did detach
          /// * View did resize
          /// * View not centered, attached to top left
          ///
          ///
          func test12(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            viewToDetach.removeFromSuperview();
            viewToDetachParent.setSize(newSize);
            
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
          
          /// Paper
          /// Base: test01, test12
          ///
          /// remove parent content from superview
          /// delay, attach parent content to window
          /// update size of view
          ///
          /// result: wrong
          /// * Same as `test10` -> `test12`
          ///
          func test13(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            viewToDetach.removeFromSuperview();
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              viewToDetachParent.setSize(newSize);
            
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
          
          /// Paper
          /// Base: test01, test13
          ///
          /// remove parent content from superview
          /// update size of view
          /// delay, attach parent content to window
          ///
          /// result: ok
          /// * View did detach
          /// * View did resize
          /// * View centered
          ///
          func test14(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            viewToDetach.removeFromSuperview();
            viewToDetachParent.setSize(newSize);
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
          
          /// Paper
          /// Base: test01, test14
          ///
          /// remove parent content from superview
          /// delay, attach parent content to window
          /// delay, update size of view
          ///
          /// results: wrong
          /// * resizing view causes view to not center
          /// * refresh causes view to center
          ///
          /// * view did detach, centered wrong size
          /// * view did resize, moved to top left
          ///
          func test15(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            viewToDetach.removeFromSuperview();
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
              viewToDetachParent.setSize(newSize);
            };
          };
          
          /// Paper
          /// Base: test01, test15
          ///
          /// remove parent content from superview
          /// delay, attach parent content to window
          /// delay, update size of view
          /// layout content + parent
          ///
          /// results: wrong
          /// * same as `test15`
          ///
          func test16(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            viewToDetach.removeFromSuperview();
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
              viewToDetachParent.setSize(newSize);
              viewToDetachParent.layoutIfNeeded();
              
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
            };
          };
          
          /// Paper
          /// Base: test01, test16
          ///
          /// remove wrapper + detached parent content from superview
          /// delay, attach parent content to window
          /// delay, update size of view
          /// layout content + parent
          ///
          /// results: wrong
          /// * same as `test15` -> `test16`
          ///
          func test17(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            sender.removeFromSuperview();
            viewToDetachParent.removeFromSuperview();
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
              viewToDetachParent.setSize(newSize);
              viewToDetachParent.layoutIfNeeded();
              
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
            };
          };
          
          /// Paper
          /// Base: test01, test14
          ///
          /// remove wrapper + detached parent content from superview
          /// update size of view
          /// delay, attach parent content to window
          ///
          /// result: ok
          /// * same as `test14`
          ///
          func test18(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            sender.removeFromSuperview();
            viewToDetach.removeFromSuperview();
            viewToDetachParent.setSize(newSize);
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
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
          
          /// Paper
          /// Base: test01, test16
          ///
          /// remove wrapper + detached parent content from superview
          /// delay, attach parent content to window
          /// delay, update size of view
          /// layout content + parent
          /// re-activate constraints
          ///
          /// results: wrong
          /// * same as: `test15` -> `test17`
          ///
          func test19(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            sender.removeFromSuperview();
            viewToDetachParent.removeFromSuperview();
            
            var prevConstraints: [NSLayoutConstraint] = [];
            
            func setConstraints(){
              prevConstraints.forEach {
                $0.isActive = false;
              };
              
              let constraints: [NSLayoutConstraint] = [
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
              ];
              
              NSLayoutConstraint.activate(constraints);
              prevConstraints = constraints;
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              setConstraints();
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
              viewToDetachParent.setSize(newSize);
              viewToDetachParent.layoutIfNeeded();
              
              setConstraints();
              
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
            };
          };
          
          /// Paper
          /// Base: test01, test19
          ///
          /// remove wrapper + detached parent content from superview
          /// delay, attach parent content to window
          /// delay, update size of view
          /// delay, re-activate constraints
          /// layout content + parent
          ///
          /// results: wrong
          /// * same as: `test15` -> `test17`, `test19`
          ///
          func test20(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            sender.removeFromSuperview();
            viewToDetachParent.removeFromSuperview();
            
            var prevConstraints: [NSLayoutConstraint] = [];
            
            func setConstraints(){
              prevConstraints.forEach {
                $0.isActive = false;
              };
              
              let constraints: [NSLayoutConstraint] = [
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
              ];
              
              NSLayoutConstraint.activate(constraints);
              prevConstraints = constraints;
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
              setConstraints();
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
              viewToDetachParent.setSize(newSize);
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
              setConstraints();
              
              viewToDetachParent.layoutIfNeeded();
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
            };
          };
          
          
          /// Paper
          /// Base: test01, test20
          ///
          /// remove wrapper + detached parent content from superview
          /// delay, attach parent content to window
          /// delay, update size of view
          /// delay, re-attach to window + re-activate constraints
          /// layout content + parent
          ///
          /// results: ok
          /// * view did detach, centered wrong size
          /// * view did resize, moved to top left
          /// * view did center after 3rd delay
          ///
          ///
          func test21(){
            let viewToDetachParent = self.subviews.first! as! RNIContentViewParentDelegate;
            let viewToDetach = viewToDetachParent;
            
            sender.removeFromSuperview();
            viewToDetach.removeFromSuperview();
            
            var prevConstraints: [NSLayoutConstraint] = [];
            
            func attachToWindow(){
              viewToDetach.translatesAutoresizingMaskIntoConstraints = false;
              window.addSubview(viewToDetach);
            };
            
            func setConstraints(){
              prevConstraints.forEach {
                $0.isActive = false;
              };
              
              let constraints: [NSLayoutConstraint] = [
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
              ];
              
              NSLayoutConstraint.activate(constraints);
              prevConstraints = constraints;
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              attachToWindow();
              setConstraints();
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
              viewToDetachParent.setSize(newSize);
            };
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
              attachToWindow();
              setConstraints();
              
              viewToDetachParent.layoutIfNeeded();
              viewToDetach.setNeedsLayout();
              viewToDetach.layoutIfNeeded();
            };
          };
          
          
          /// Paper
          /// Base: test06
          ///
          /// wrap react view in VC
          /// update size in `viewDidLayoutSubviews`
          ///
          /// results: wrong
          /// * did not detach, still in the same place
          /// * view did resize, cropped
          ///
          ///
          func test22(){
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
                self.contentParent.setSize(self.view.bounds.size);
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
          
          /// Paper
          /// Base: test06 (fabric), test22
          ///
          /// wrap react view in VC
          /// update size in `viewDidLayoutSubviews`
          ///
          /// results: ok
          /// * same as `test06`
          ///
          ///
          func test23(){
            let viewToDetach =
              self.subviews.first! as! RNIContentViewParentDelegate;
            
            class WrapperViewController: UIViewController {
              weak var content: RNIContentViewParentDelegate!;
            
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
                self.content.setSize(self.view.bounds.size);
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          #endif
          
          /// Paper + Fabric
          /// Base: test06 (fabric), test23
          ///
          /// wrap wrapperView parent in VC
          /// update size in `viewDidLayoutSubviews`
          ///
          /// results - paper: ok
          /// * same as `test06`
          ///
          /// results - fabric: ok
          /// * same as `test06`
          ///
          ///
          func test24(){
            let viewToDetach =
              self.subviews.first! as! RNIContentViewParentDelegate;
            
            class WrapperViewController: UIViewController {
              weak var content: RNIContentViewParentDelegate!;
            
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
                self.content.setSize(self.view.bounds.size);
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          /// Paper + Fabric
          /// Base: test06 (fabric), test24
          ///
          /// wrap wrapperView parent in VC
          /// remove detachedView from superview
          /// update size in `viewDidLayoutSubviews`
          ///
          /// results - paper:
          /// * not tested, but should be ok
          /// * same as `test06`
          ///
          /// results - fabric: ok
          /// * same as `test06`, `test22` -> `test23`
          /// * refresh causes crash
          ///
          ///
          func test25(){
            let viewToDetach =
              self.subviews.first! as! RNIContentViewParentDelegate;
            
            sender.removeFromSuperview();
            
            class WrapperViewController: UIViewController {
              weak var content: RNIContentViewParentDelegate!;
            
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
                self.content.setSize(self.view.bounds.size);
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          /// Paper + Fabric
          /// Base: test06 (fabric), test24
          ///
          /// wrap wrapperView parent in VC
          /// detach detachedview
          /// add touch hadnler
          /// update size in `viewDidLayoutSubviews`
          ///
          /// results - paper: ok
          /// * same as `test06`, `test22` -> `test24`
          /// * touches work
          ///
          /// results - fabric: no
          /// * same as `test06`, `test22` -> `test24`
          /// * touches dont work
          ///
          ///
          func test26(){
            let viewToDetach =
              self.subviews.first! as! RNIContentViewParentDelegate;
              
            let bridge = RCTBridge.current();
            let touchHandler: RCTTouchHandler = .init(bridge: bridge);
            
            touchHandler.attach(to: viewToDetach);
            
            
            #if RCT_NEW_ARCH_ENABLED
            sender.setPositionType(.absolute);
            sender.backgroundColor = .clear;
            sender.alpha = 0.01;
            #else
            sender.removeFromSuperview();
            #endif
            
            class WrapperViewController: UIViewController {
              weak var content: RNIContentViewParentDelegate!;
            
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
                self.content.setSize(self.view.bounds.size);
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          /// Paper + Fabric
          /// Base: test06 (fabric), test24
          ///
          /// wrap wrapperView parent in VC
          /// detach detachedview
          /// add touch hadnler
          /// update size in `viewDidLayoutSubviews`
          ///
          /// results - paper: ok
          /// * same as `test06`, `test22` -> `test25`
          /// * touches work
          ///
          /// results - fabric: ok
          /// * same as `test06`, `test22` -> `test25`
          /// * touches work
          ///
          ///
          func test27(){
            let viewToDetach =
              self.subviews.first! as! RNIContentViewParentDelegate;
              
            
            #if RCT_NEW_ARCH_ENABLED
            sender.setPositionType(.absolute);
            sender.backgroundColor = .clear;
            sender.alpha = 0.01;
            
            viewToDetach.attachReactTouchHandler();
            #else
            sender.removeFromSuperview();
            
            let bridge = RCTBridge.current();
            let touchHandler: RCTTouchHandler = .init(bridge: bridge);
            
            touchHandler.attach(to: viewToDetach);
            #endif
            
            class WrapperViewController: UIViewController {
              weak var content: RNIContentViewParentDelegate!;
            
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
                self.content.setSize(self.view.bounds.size);
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          func test28(){
            let viewToDetach =
              self.subviews.first! as! RNIContentViewParentDelegate;
              
            
            #if RCT_NEW_ARCH_ENABLED
            sender.setPositionType(.absolute);
            sender.backgroundColor = .clear;
            sender.alpha = 0.01;
            
            viewToDetach.attachReactTouchHandler();
            #else
            sender.removeFromSuperview();
            
            let bridge = RCTBridge.current();
            let touchHandler: RCTTouchHandler = .init(bridge: bridge);
            
            touchHandler.attach(to: viewToDetach);
            #endif
            
            class WrapperViewController: UIViewController {
              weak var content: RNIContentViewParentDelegate!;
              var contentPositionConfig: AlignmentPositionConfig = .default;
            
              override func viewDidLoad() {
                self.content.translatesAutoresizingMaskIntoConstraints = false;
                self.view.addSubview(content);
                
                let window = UIApplication.shared.activeWindow!;
                
                let constraints = self.contentPositionConfig.createConstraints(
                  forView: self.content,
                  attachingTo: self.view,
                  enclosingView: self.view
                );
                
                NSLayoutConstraint.activate(constraints);
              };
              
              override func viewDidLayoutSubviews() {
                self.content.setSize(self.view.bounds.size);
              };
            };
            
            let childVC = WrapperViewController();
            childVC.content = viewToDetach;
            childVC.contentPositionConfig = contentPositionConfig;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          func test29() throws {
            guard let viewToDetach = self.viewToDetach else {
              throw RNIUtilitiesError(errorCode: .unexpectedNilValue);
            };
            
            try self.detach();
            
            let childVC = RNIBaseViewController();
            childVC.rootReactView = viewToDetach;
            childVC.positionConfig = contentPositionConfig;
            
            let rootVC = window.rootViewController!;
            rootVC.view.addSubview(childVC.view);
            rootVC.addChild(childVC);
            childVC.didMove(toParent: rootVC);
          };
          
          
          try test29();
          
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
              #if RCT_NEW_ARCH_ENABLED
              self.contentParent.requestToUpdateState(
                .init(
                  shouldSetSize: true,
                  frameSize: self.view.bounds.size
                )
              );
              #else
              self.contentParent.setSize(self.view.bounds.size);
              #endif
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
