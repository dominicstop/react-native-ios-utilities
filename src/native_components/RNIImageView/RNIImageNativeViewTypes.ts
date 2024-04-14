import type { ViewProps } from 'react-native';
import type { RNIViewCleanupModeProp } from '../../types/RNIViewCleanupModeProp';
import { ImageItemConfig } from '../../types/ImageItemConfig';
import { UIImageSymbolConfigurationInit } from '../../types/NativeTypes';

export type RNIImageNativeViewBaseProps = {
  imageConfig: ImageItemConfig;
  preferredSymbolConfiguration: UIImageSymbolConfigurationInit | undefined;
};

export type RNIImageNativeViewProps = 
  & RNIViewCleanupModeProp
  & RNIImageNativeViewBaseProps 
  & ViewProps;
