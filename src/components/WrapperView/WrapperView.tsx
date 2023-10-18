import * as React from 'react';
import { LayoutChangeEvent, View } from 'react-native';

import type { WrapperViewProps } from './WrapperViewTypes';

export class WrapperView extends React.PureComponent<WrapperViewProps> {
  
  nativeRef?: View;
  reactTag?: number;

  componentWillUnmount() {
    this.reactTag = undefined;
  };

  getViewRef = () => {
    return this.nativeRef;
  };

  getNativeReactTag: () => number | undefined = () => {
    // @ts-ignore
    return this.nativeRef?.nativeTag ?? this.reactTag;
  };

  private _handleViewRef = (ref: View) => {
    this.nativeRef = ref;
  };

  private _handleOnLayout = (event: LayoutChangeEvent) => {
    this.props.onLayout?.(event);

    // @ts-ignore
    this.reactTag = event.nativeEvent.target;
  };

  render() {
    const { children, ...otherProps } = this.props;
    const didSetReactTag = this.reactTag != null;

    return(
      <View 
        {...otherProps}
        ref={this._handleViewRef}
        onLayout={didSetReactTag 
          ? undefined
          : this._handleOnLayout
        }
      >
        {children}
      </View>
    );  
  };
};