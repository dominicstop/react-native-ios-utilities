import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ReactNativeIosUtilities.web.ts
// and on native platforms to ReactNativeIosUtilities.ts
import ReactNativeIosUtilitiesModule from './ReactNativeIosUtilitiesModule';
import ReactNativeIosUtilitiesView from './ReactNativeIosUtilitiesView';
import { ChangeEventPayload, ReactNativeIosUtilitiesViewProps } from './ReactNativeIosUtilities.types';

// Get the native constant value.
export const PI = ReactNativeIosUtilitiesModule.PI;

export function hello(): string {
  return ReactNativeIosUtilitiesModule.hello();
}

export async function setValueAsync(value: string) {
  return await ReactNativeIosUtilitiesModule.setValueAsync(value);
}

const emitter = new EventEmitter(ReactNativeIosUtilitiesModule ?? NativeModulesProxy.ReactNativeIosUtilities);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ReactNativeIosUtilitiesView, ReactNativeIosUtilitiesViewProps, ChangeEventPayload };
