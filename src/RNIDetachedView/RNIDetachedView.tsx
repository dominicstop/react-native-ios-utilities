import * as React from 'react';
import { StyleSheet } from 'react-native';

import { RNIDetachedViewModule } from './RNIDetachedViewModule';
import { RNIDetachedNativeView } from './RNIDetachedNativeView';

import type { RNIDetachedViewProps, RNIDetachedViewState } from './RNIDetachedViewTypes';
import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';

import type { OnReactTagDidSetEvent } from '../types/SharedEvents';


export class RNIDetachedView extends React.PureComponent<RNIDetachedViewProps, RNIDetachedViewState> {
  
  reactTag?: number; type

  constructor(props: RNIDetachedViewProps){
    super(props);

    this.state = {
      isDetached: false,
    };
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

  notifyComponentWillUnmount = (isManuallyTriggered: boolean = true) => {
    const reactTag = this.reactTag;
    if(typeof reactTag !== 'number') return;

    RNIDetachedViewModule.notifyComponentWillUnmount(
      reactTag, 
      isManuallyTriggered
    );
  };

  private _handleOnReactTagDidSet: OnReactTagDidSetEvent = ({nativeEvent}) => {
    this.reactTag = nativeEvent.reactTag;
  };

  private _handleOnViewDidDetach: OnDetachedViewDidDetachEvent = ({nativeEvent}) => {
    this.setState({ isDetached: true });
  };

  render(){
    const props = this.getProps();
    const state = this.state;

    return React.createElement(RNIDetachedNativeView, {
      ...props,
      style: {
        ...styles.nativeView,
        ...(!state.isDetached && {
          opacity: 0.001,
          width: 0,
          height: 0,
        }),
      },
      onReactTagDidSet: this._handleOnReactTagDidSet,
      onViewDidDetach: this._handleOnViewDidDetach,
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
  },
});