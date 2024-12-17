import type { OnDidSetViewIDEventPayload } from "./SharedViewEvents";


export type Point = {
  x: number;
  y: number;
};

/** Object return by `DynamicColorIOS` */
export type DynamicColor = {
  dynamic: {
    dark: string;
    light: string;
  };
} | {
  dark: string;
  light: string;
};

export type ColorValue = string | DynamicColor;

// Native Type: `RNINativeViewIdentifier`
export type NativeViewIdentifier = {
  reactTag: OnDidSetViewIDEventPayload['reactTag'];
} | {
  viewID: OnDidSetViewIDEventPayload['viewID'];
};