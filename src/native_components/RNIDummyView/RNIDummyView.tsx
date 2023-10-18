import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View } from 'react-native';

import { RNIDummyViewModule } from './RNIDummyViewModule';
import { RNIDummyNativeView } from './RNIDummyNativeView';

import type { RNIDummyViewProps } from './RNIDummyViewTypes';


export class RNIDummyView extends React.PureComponent<RNIDummyViewProps> {
  
  nativeRef?: View;

  constructor(props: RNIDummyViewProps){
    super(props);
  };

  getProps() {
    const { 
      shouldCleanupOnComponentWillUnmount, 
      ...viewProps 
    } = this.props;

    return {
      shouldCleanupOnComponentWillUnmount: 
        shouldCleanupOnComponentWillUnmount ?? false,

      viewProps,
    };
  };

  componentWillUnmount(){
    this.notifyOnComponentWillUnmount(false);
  };

  getNativeRef: () => View | undefined = () => {
    return this.nativeRef;
  };

  getNativeReactTag: () => number | undefined = () => {
    // @ts-ignore
    return this.nativeRef?.nativeTag;
  };

  notifyOnComponentWillUnmount = async (
    isManuallyTriggered: boolean = true
  ) => {
    const reactTag = this.getNativeReactTag();
    if(typeof reactTag !== 'number') return;

    await RNIDummyViewModule.notifyOnComponentWillUnmount(
      reactTag, 
      isManuallyTriggered
    );
  };

  render(){
    const props = this.getProps();

    return React.createElement(RNIDummyNativeView, {
      ...props.viewProps,
      style: [
        props.viewProps.style,
        styles.nativeView,        
      ],
      // @ts-ignore
      ref: this._handleOnNativeRef,
      shouldCleanupOnComponentWillUnmount: props.shouldCleanupOnComponentWillUnmount,
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
    opacity: 0.01,
  },
});