import { CGRect, CGSize, UIEdgeInsets, UIDevice, UIUserInterfaceIdiom, UIDeviceOrientation, UIInterfaceOrientation, UITraitEnvironmentLayoutDirection, UIUserInterfaceActiveAppearance, UIUserInterfaceLevel, UIUserInterfaceSizeClass, UIUserInterfaceStyle, CGRectBase } from "../NativeTypes";
import { NumericLogicalExpression } from "./NumericLogicalExpression";
import { EvaluableConditionContext } from "./EvaluableConditionContext";
import { StringComparisonMode } from "./StringComparisonMode";
import { KeysWithType } from "../UtilityTypes";

export type EvaluableConditionFrameRectValue = {
 mode: 'window'; 
} | {
 mode: 'targetView';
} | {
 mode: 'statusBar';
} | {
 mode: 'custom';
 value: CGRectBase;
};

export type EvaluableConditionSizeValue =  { 
  mode: 'window';
} | { 
  mode: 'screen';
} | { 
  mode: 'statusBar';
} | { 
  mode: 'targetView';
} | {
  mode: 'custom';
  value: number;
};
    
export type EvaluableCondition = {
  mode: 'frameRect';
  of: EvaluableConditionFrameRectValue;
  valueForKey: keyof CGRect;
  condition: NumericLogicalExpression;
} | {
  mode: 'size';
  of: EvaluableConditionSizeValue;
  valueForKey: keyof CGSize;
  condition: NumericLogicalExpression;
} | {
  mode: 'safeAreaInsets';
  valueForKey: keyof UIEdgeInsets;
  condition: NumericLogicalExpression;
} | {
  mode: 'deviceIdiom';
  isEqualTo: UIUserInterfaceIdiom;
} | {
  mode: 'deviceOrientation';
  isEqualTo: UIDeviceOrientation;
} | {
  mode: 'horizontalSizeClass';
  isEqualTo: UIUserInterfaceSizeClass;
} | {
  mode: 'verticalSizeClass';
  isEqualTo: UIUserInterfaceSizeClass;
} | {
  mode: 'interfaceStyle';
  isEqualTo: UIUserInterfaceStyle;
} | {
  mode: 'interfaceLevel';
  isEqualTo: UIUserInterfaceLevel;
} | {
  mode: 'interfaceOrientation';
  isEqualTo: UIInterfaceOrientation;
} | {
  mode: 'activeAppearance';
  isEqualTo: UIUserInterfaceActiveAppearance;
} | {
  mode: 'layoutDirection';
  isEqualTo: UITraitEnvironmentLayoutDirection;
} | {
  mode: 'isFlagTrue';
  isEqualToKey: KeysWithType<EvaluableConditionContext, boolean>;
} | {
  mode: 'deviceFlags';
  isEqualToKey: KeysWithType<UIDevice, boolean>;
} | {
  mode: 'deviceString';
  forKey: KeysWithType<UIDevice, string>;
  stringComparisonMode: StringComparisonMode;
  isCaseSensitive: boolean;
  stringValue: string;
} | {
  mode: 'customFlag';
  value: boolean;
} | {
  mode: 'negate'
  value: EvaluableCondition;
} | {
  mode: 'ifAnyAreTrue'
  values: EvaluableCondition[];
} | {
  mode: 'ifAllAreTrue'
  values: EvaluableCondition[];
};