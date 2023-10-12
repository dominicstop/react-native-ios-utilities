import * as React from 'react';
import { StyleSheet } from 'react-native';

import { RNIDummyViewModule } from './RNIDummyViewModule';
import { RNIDummyNativeView } from './RNIDummyNativeView';

import type { RNIDummyViewProps } from './RNIDummyViewTypes';
import type { OnReactTagDidSetEvent } from '../types/SharedEvents';


export class RNIDummyView extends React.PureComponent<RNIDummyViewProps> {
  
  reactTag?: number;

  constructor(props: RNIDummyViewProps){
    super(props);
  };

  getProps() {
    const { 
      shouldCleanupOnComponentWillUnmount, 
      ...otherProps 
    } = this.props;

    return {
      shouldCleanupOnComponentWillUnmount: 
        shouldCleanupOnComponentWillUnmount ?? false,

      ...otherProps,
    };
  };

  componentWillUnmount(){
    this.notifyComponentWillUnmount(false);
  };

  notifyComponentWillUnmount = async (
    isManuallyTriggered: boolean = true
  ) => {
    const reactTag = this.reactTag;
    if(typeof reactTag !== 'number') return;

    await RNIDummyViewModule.notifyComponentWillUnmount(
      reactTag, 
      isManuallyTriggered
    );
  };

  private _handleOnReactTagDidSet: OnReactTagDidSetEvent = ({nativeEvent}) => {
    this.reactTag = nativeEvent.reactTag;
  };

  render(){
    const props = this.getProps();

    return React.createElement(RNIDummyNativeView, {
      ...props,
      style: styles.nativeDummyView,
      onReactTagDidSet: this._handleOnReactTagDidSet,
    });
  };
};

const styles = StyleSheet.create({
  nativeDummyView: {
    position: 'absolute',
    opacity: 0.01,
  },
});