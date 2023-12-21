import { CGRect, CGSize } from "react-native-ios-utilities";
import { NumericLogicalExpression } from "./NumericLogicalExpression";
import { UIEdgeInsets } from "../TempTypes/UIGeometry";
import { UIDevice, UIUserInterfaceIdiom } from "../TempTypes/UIDevice";
import { UIDeviceOrientation } from "../TempTypes/UIOrientation";
import { UIInterfaceOrientation, UITraitEnvironmentLayoutDirection, UIUserInterfaceActiveAppearance, UIUserInterfaceLevel, UIUserInterfaceSizeClass, UIUserInterfaceStyle } from "../TempTypes/UIInterface";
import { EvaluableConditionContext } from "./EvaluableConditionContext";
import { StringComparisonMode } from "./StringComparisonMode";
import { KeysWithType } from "../UtilityTypes";

export type FrameRectValue =
  | 'window'
  | 'targetView'
  | 'statusBar'
  | 'custom';

export type SizeValue =  { 
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
  of: FrameRectValue;
  valueForKey: keyof CGRect;
  condition: NumericLogicalExpression;
} | {
  mode: 'size';
  of: SizeValue;
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
  value: EvaluableCondition[];
} | {
  mode: 'ifAllAreTrue'
  value: EvaluableCondition[];
};