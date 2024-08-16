import type { UniformKeyAndValue } from "../types/UtilityTypes";


const UIBlurEffectStylesRaw = {
  // iOS 10+
  regular: 'regular',
  prominent: 'prominent',
  extraLight: 'extraLight',
  light: 'light',
  dark: 'dark',

  // iOS 13+
  systemUltraThinMaterial: 'systemUltraThinMaterial',
  systemThinMaterial: 'systemThinMaterial',
  systemMaterial: 'systemMaterial',
  systemThickMaterial: 'systemThickMaterial',
  systemChromeMaterial: 'systemChromeMaterial',
  systemUltraThinMaterialLight: 'systemUltraThinMaterialLight',
  systemThinMaterialLight: 'systemThinMaterialLight',
  systemMaterialLight: 'systemMaterialLight',
  systemThickMaterialLight: 'systemThickMaterialLight',
  systemChromeMaterialLight: 'systemChromeMaterialLight',
  systemUltraThinMaterialDark: 'systemUltraThinMaterialDark',
  systemThinMaterialDark: 'systemThinMaterialDark',
  systemMaterialDark: 'systemMaterialDark',
  systemThickMaterialDark: 'systemThickMaterialDark',
  systemChromeMaterialDark: 'systemChromeMaterialDark',
};

export type UIBlurEffectStyle = keyof (typeof UIBlurEffectStylesRaw);

export const UIBlurEffectStyles = 
  UIBlurEffectStylesRaw as UniformKeyAndValue<UIBlurEffectStyle>;

export const UIBlurEffectStyleItems = 
  Object.keys(UIBlurEffectStyles) as Array<UIBlurEffectStyle>;