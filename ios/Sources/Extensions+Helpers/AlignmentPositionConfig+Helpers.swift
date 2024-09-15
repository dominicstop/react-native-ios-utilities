//
//  AlignmentPositionConfig+Helpers.swift
//  react-native-ios-utilities
//
//  Created by Dominic Go on 9/15/24.
//

import Foundation
import DGSwiftUtilities


public extension AlignmentPositionConfig {
  
  func setIntrinsicContentSizeOverrideIfNeeded(
    forRootReactView rootReactView: RNIContentViewParentDelegate,
    withSize newSize: CGSize
  ){
    
    switch (self.horizontalAlignment, self.verticalAlignment) {
      case (.stretch, .stretch):
        break;
        
      case (.stretchTarget, .stretchTarget):
        break;
        
      case (.stretchTarget, _):
        fallthrough;
        
      case(.stretch, _):
        let newWidth = newSize.width;
        
        guard rootReactView.intrinsicContentSize.width != newWidth else {
          return;
        };
          
        rootReactView.intrinsicContentSizeOverride = .init(
          width: newWidth,
          height: 0
        );
        
        rootReactView.invalidateIntrinsicContentSize();

        case (_, .stretchTarget):
          fallthrough;

        case (_, .stretch):
          let newHeight = newSize.height;
          
          guard rootReactView.intrinsicContentSize.height != newHeight else {
            return;
          };
          
          rootReactView.intrinsicContentSizeOverride = .init(
            width: 0,
            height: newSize.height
          );
          
          rootReactView.invalidateIntrinsicContentSize();
      
      default:
        break;
    };
  };
  
  func applySize(
    toRootReactView rootReactView: RNIContentViewParentDelegate,
    attachingTo targetView: UIView
  ){
    switch (
      self.horizontalAlignment,
      self.verticalAlignment
    ) {
      case (.stretch, .stretch):
        fallthrough;
        
      case (.stretchTarget, .stretchTarget):
        rootReactView.setSize(targetView.bounds.size);
        
      case (.stretchTarget, _):
        fallthrough;
        
      case(.stretch, _):
        let newWidth = targetView.bounds.width;
        
        #if RCT_NEW_ARCH_ENABLED
        rootReactView.requestToUpdateState(
          .init(
            minSize: .init(width: newWidth, height: 0),
            shouldSetMinWidth: true
          )
        );
        #else
        guard let shadowView = rootReactView.cachedShadowView,
              CGFloat(shadowView.minWidth.value) != newWidth
        else {
          return;
        };
        
        shadowView.minWidth = .init(
          value: Float(newWidth),
          unit: .point
        );
        
        shadowView.dirtyLayout();
        #endif

        case (_, .stretchTarget):
          fallthrough;

        case (_, .stretch):
          let newHeight = targetView.bounds.height;
          
          #if RCT_NEW_ARCH_ENABLED
          rootReactView.requestToUpdateState(
            .init(
              minSize: .init(width: 0, height: newHeight),
              shouldSetMinHeight: true
            )
          );
          #else
          guard let shadowView = rootReactView.cachedShadowView,
                CGFloat(shadowView.minHeight.value) != newHeight
          else {
            return;
          };
          
          shadowView.minHeight = .init(
            value: Float(newHeight),
            unit: .point
          );
          
          shadowView.dirtyLayout();
          #endif

      default:
        break;
    };
  };
};
