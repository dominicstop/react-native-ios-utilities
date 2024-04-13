import * as React from 'react';
import { LayoutChangeEvent, View } from 'react-native';

import { RNIImageViewModule } from './RNIImageViewModule';
import { RNIImageNativeView } from './RNIImagNativeView';

import type { RNIImageViewProps } from './RNIImageViewTypes';


export class RNIImageView extends React.PureComponent<RNIImageViewProps> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNIImageViewProps){
    super(props);
  };

  private getProps() {
    const { 
      imageConfig,
      ...viewProps
    } = this.props;

    return {
      nativeProps: {
        imageConfig,
      },
      viewProps,
    };
  };

  getNativeRef: () => View | undefined = () => {
    return this.nativeRef;
  };

  getNativeReactTag: () => number | undefined = () => {
    // @ts-ignore
    return this.nativeRef?.nativeTag ?? this.reactTag;
  };

  private _handleOnLayout = (event: LayoutChangeEvent) => {
    this.props.onLayout?.(event);

    // @ts-ignore
    this.reactTag = event.nativeEvent.target;
  };

  private _handleOnNativeRef = (ref: View) => {
    this.nativeRef = ref;
  };

  render(){
    const props = this.getProps();
    const didSetReactTag = this.reactTag != null;

    return React.createElement(RNIImageNativeView, {
      ...props.viewProps,
      ...props.nativeProps,
      // @ts-ignore
      ref: this._handleOnNativeRef,
      onLayout: (didSetReactTag 
        ? undefined
        : this._handleOnLayout
      ),
    });
  };
};