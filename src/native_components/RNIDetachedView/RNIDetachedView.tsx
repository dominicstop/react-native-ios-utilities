import * as React from 'react';
import { LayoutChangeEvent, StyleSheet, View, ViewStyle } from 'react-native';

import { RNIDetachedViewModule } from './RNIDetachedViewModule';
import { RNIDetachedNativeView } from './RNIDetachedNativeView';

import type { RNIDetachedViewProps, RNIDetachedViewState } from './RNIDetachedViewTypes';
import type { OnDetachedViewDidDetachEvent } from './RNIDetachedViewEvents';


export class RNIDetachedView extends React.PureComponent<RNIDetachedViewProps, RNIDetachedViewState> {
  
  nativeRef?: View;
  reactTag?: number;

  constructor(props: RNIDetachedViewProps){
    super(props);

    this.state = {
      isDetached: false,
    };
  };

  componentWillUnmount(){
    const props = this.getProps();
    if(!props.shouldNotifyOnComponentWillUnmount) return;

    this.notifyOnComponentWillUnmount(false);
    this.reactTag = undefined;
  };

  getProps() {
    const { 
      shouldCleanupOnComponentWillUnmount,
      shouldApplyStyleOverride,
      shouldNotifyOnComponentWillUnmount,
      ...viewProps 
    } = this.props;

    return {
      shouldCleanupOnComponentWillUnmount: 
        shouldCleanupOnComponentWillUnmount ?? false,

      shouldApplyStyleOverride: 
        shouldApplyStyleOverride ?? true,

      shouldNotifyOnComponentWillUnmount:
        shouldNotifyOnComponentWillUnmount ?? false,

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

  notifyOnComponentWillUnmount = async (
    isManuallyTriggered: boolean = true
  ) => {
    const reactTag = this.getNativeReactTag();
    if(typeof reactTag !== 'number') return;

    await RNIDetachedViewModule.notifyOnComponentWillUnmount(
      reactTag, 
      isManuallyTriggered
    );
  };

  private _handleOnNativeRef = (ref: View) => {
    this.nativeRef = ref;
  };

  private _handleOnViewDidDetach: OnDetachedViewDidDetachEvent = (event) => {
    this.setState({ isDetached: true });
    this.props.onViewDidDetach?.(event);
  };

  render(){
    const props = this.getProps();
    const state = this.state;

    const didSetReactTag = this.reactTag != null;

    const nativeStyleOverride: ViewStyle = {
      ...(!state.isDetached && {
        opacity: 0.001,
        width: 0,
        height: 0,
      }),
    };
    
    return React.createElement(RNIDetachedNativeView, {
      ...props.viewProps,
      style: (props.shouldApplyStyleOverride ? [
        props.viewProps.style,
        styles.nativeView,        
        nativeStyleOverride,
      ] : [
        props.viewProps.style,
      ]),
      // @ts-ignore
      ref: this._handleOnNativeRef,
      onLayout: (didSetReactTag 
        ? undefined
        : this._handleOnLayout
      ),
      onViewDidDetach: this._handleOnViewDidDetach,
      shouldCleanupOnComponentWillUnmount: props.shouldCleanupOnComponentWillUnmount,
    });
  };
};

const styles = StyleSheet.create({
  nativeView: {
    position: 'absolute',
  },
});