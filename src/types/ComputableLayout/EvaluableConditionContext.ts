import type { CGRectNative, UIEdgeInsets, UIUserInterfaceIdiom, UIDeviceOrientation, UIInterfaceOrientation, UITraitEnvironmentLayoutDirection, UIUserInterfaceActiveAppearance, UIUserInterfaceLevel, UIUserInterfaceSizeClass, UIUserInterfaceStyle } from "../NativeTypes";


export type EvaluableConditionContext = {

  windowFrame?: CGRectNative;
  screenBounds: CGRectNative;

  targetViewFrame?: CGRectNative;

  statusBarFrame?: CGRectNative;
  safeAreaInsets?: UIEdgeInsets;

  interfaceOrientation: UIInterfaceOrientation;

  deviceUserInterfaceIdiom: UIUserInterfaceIdiom;

  deviceOrientation: UIDeviceOrientation;

  horizontalSizeClass?: UIUserInterfaceSizeClass;

  verticalSizeClass?: UIUserInterfaceSizeClass;

  interfaceStyle: UIUserInterfaceStyle;
    
  interfaceLevel: UIUserInterfaceLevel;
    
  activeAppearance?: UIUserInterfaceActiveAppearance;

  layoutDirection: UITraitEnvironmentLayoutDirection;

  hasNotch: boolean;

  isLowPowerModeEnabled: UIUserInterfaceIdiom;

  isAssistiveTouchRunning: UIUserInterfaceIdiom;

  isBoldTextEnabled: UIUserInterfaceIdiom;

  isClosedCaptioningEnabled: UIUserInterfaceIdiom;

  isDarkerSystemColorsEnabled: UIUserInterfaceIdiom;

  isGrayscaleEnabled: UIUserInterfaceIdiom;

  isGuidedAccessEnabled: UIUserInterfaceIdiom;

  isInvertColorsEnabled: UIUserInterfaceIdiom;

  isMonoAudioEnabled: UIUserInterfaceIdiom;

  /**
   * Availability: iOS 13.0
   */
  isOnOffSwitchLabelsEnabled: UIUserInterfaceIdiom;

  isReduceMotionEnabled: UIUserInterfaceIdiom;

  isReduceTransparencyEnabled: UIUserInterfaceIdiom;

  isShakeToUndoEnabled: UIUserInterfaceIdiom;

  isSpeakScreenEnabled: UIUserInterfaceIdiom;

  isSpeakSelectionEnabled: UIUserInterfaceIdiom;

  isSwitchControlRunning: UIUserInterfaceIdiom;

  /**
   * Availability: iOS 13.0
   */
  isVideoAutoplayEnabled: UIUserInterfaceIdiom;

  isVoiceOverRunning: UIUserInterfaceIdiom;

  /**
   * Availability: iOS 13.0
   */
  shouldDifferentiateWithoutColor: UIUserInterfaceIdiom;

  /**
   * Availability: iOS 14.0
   */
  buttonShapesEnabled: UIUserInterfaceIdiom;

  /**
   * Availability: iOS 14.0
   */
  prefersCrossFadeTransitions: UIUserInterfaceIdiom;

};