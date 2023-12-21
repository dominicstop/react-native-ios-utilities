import { CGRect } from "react-native-ios-utilities";
import { UIEdgeInsets } from "../TempTypes/UIGeometry";
import { UIInterfaceOrientation, UITraitEnvironmentLayoutDirection, UIUserInterfaceActiveAppearance, UIUserInterfaceLevel, UIUserInterfaceSizeClass, UIUserInterfaceStyle } from "../TempTypes/UIInterface";
import { UIUserInterfaceIdiom } from "../TempTypes/UIDevice";
import { UIDeviceOrientation } from "../TempTypes/UIOrientation";


export type EvaluableConditionContext = {

  windowFrame?: CGRect;
  screenBounds: CGRect;

  targetViewFrame?: CGRect;

  statusBarFrame?: CGRect;
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