import { requireNativeComponent, ViewStyle } from 'react-native';

type IosUtilitiesProps = {
  color: string;
  style: ViewStyle;
};

export const IosUtilitiesViewManager = requireNativeComponent<IosUtilitiesProps>(
'IosUtilitiesView'
);

export default IosUtilitiesViewManager;
