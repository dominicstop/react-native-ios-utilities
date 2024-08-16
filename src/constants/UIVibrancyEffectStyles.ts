import type { UniformKeyAndValue } from "../types/UtilityTypes";


const UIVibrancyEffectStylesRaw = {
  label: 'label',
  secondaryLabel: 'secondaryLabel',
  tertiaryLabel: 'tertiaryLabel',
  quaternaryLabel: 'quaternaryLabel',
  fill: 'fill',
  secondaryFill: 'secondaryFill',
  tertiaryFill: 'tertiaryFill',
  separator: 'separator',
};

export type UIVibrancyEffectStyle = keyof (typeof UIVibrancyEffectStylesRaw);

export const UIVibrancyEffectStyles = 
  UIVibrancyEffectStylesRaw as UniformKeyAndValue<UIVibrancyEffectStyle>;

export const UIVibrancyEffectStyleItems = 
  Object.keys(UIVibrancyEffectStylesRaw) as Array<UIVibrancyEffectStyle>;