import type { ViewProps } from 'react-native';
import type { RNIViewCleanupModeProp } from '../../types/RNIViewCleanupModeProp';
import { ImageItemConfig } from '../../types/ImageItemConfig';

export type RNIImageNativeViewBaseProps = {
  imageConfig: ImageItemConfig;
};

export type RNIImageNativeViewProps = 
  & RNIViewCleanupModeProp
  & RNIImageNativeViewBaseProps 
  & ViewProps;
