import type { HostComponent, ViewProps } from 'react-native';
import { default as IosUtilitiesViewNativeComponent } from './IosUtilitiesViewNativeComponent';


export interface IosUtilitiesNativeViewProps extends ViewProps {
  color: string;
  someObject: object;
}

export const IosUtilitiesNativeView = 
  IosUtilitiesViewNativeComponent as unknown as HostComponent<IosUtilitiesNativeViewProps>;
