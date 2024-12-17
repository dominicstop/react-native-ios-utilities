import type { Point } from "../MiscTypes";
import type { ImageRectConfig } from "./ImageRectConfig";


export type ImageGradientPointPreset = 
  | 'top' 
  | 'bottom' 
  | 'left' 
  | 'right'
  | 'bottomLeft' 
  | 'bottomRight' 
  | 'topLeft' 
  | 'topRight';

export type ImageGradientConfig = Partial<Pick<ImageRectConfig, 
  | 'width'
  | 'height'
  | 'borderRadius'
>> & {
  /* An array defining the color of each gradient stop. */
  colors: Array<string>;

  /* Defines the location of each gradient stop. */
  locations?: Array<number>;

  /* The start point of the gradient when drawn in the layer’s coordinate space. */
  startPoint?: Point | ImageGradientPointPreset;

  /* The end point of the gradient when drawn in the layer’s coordinate space. */
  endPoint?: Point | ImageGradientPointPreset;
  
  /* Style of gradient drawn by the layer. Defaults to axial. */
  type?: 'axial' | 'conic' | 'radial'
};