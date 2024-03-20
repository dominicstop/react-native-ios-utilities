
import * as React from 'react';
import { Alert } from 'react-native';

import { TSEventEmitter } from '@dominicstop/ts-event-emitter';
import { Helpers, KeyMapType } from 'react-native-ios-utilities';
import { ContextMenuView, ContextMenuViewProps, OnMenuDidHideEventObject, OnMenuDidShowEventObject } from 'react-native-ios-context-menu';

import { ExampleItemProps } from '../SharedExampleTypes';
import { ContextMenuCard } from '../../components/ContextMenuCard';

import { ContextMenuConfigPresets } from './ContextMenuConfigPresets';
import { CardButton } from '../../components/Card';



enum ContextMenuEmitterEvents {
  onMenuDidHide = "onMenuDidHide",
  onMenuDidShow = "onMenuDidShow",
};

export type ContextMenuEmitterEventMap = KeyMapType<ContextMenuEmitterEvents, {
  onMenuDidHide: OnMenuDidHideEventObject['nativeEvent'],
  onMenuDidShow: OnMenuDidShowEventObject['nativeEvent']
}>

export type ContextMenuEventEmitter = 
  TSEventEmitter<ContextMenuEmitterEvents, ContextMenuEmitterEventMap>;

export function ContextMenuTest01(props: ExampleItemProps) {
  const menuRef = React.useRef<ContextMenuView>(null);
  const EventEmitterRef = React.useRef<ContextMenuEventEmitter | null>(null);

  const [presetCounter, setPresetCounter] = React.useState(0);

  React.useEffect(() => {
    EventEmitterRef.current = new TSEventEmitter();
  }, []);

  const presetIndex = 
    presetCounter % ContextMenuConfigPresets.length;
  
  const currentPreset = 
    ContextMenuConfigPresets[presetIndex];

  const presetProps: ContextMenuViewProps = {
    previewConfig: undefined,
    renderPreview: undefined,
    ...currentPreset,
  };

  return(
    <ContextMenuView
      {...presetProps}
      style={props.style}
      ref={menuRef}
      onPressMenuItem={({nativeEvent}) => {
        Alert.alert(
          'onPressMenuItem Event',
          `actionKey: ${nativeEvent.actionKey} - actionTitle: ${nativeEvent.actionTitle}`
        );
      }}
      onMenuDidShow={(event) => {
        console.log("onMenuDidShow");
        EventEmitterRef.current!.emit('onMenuDidShow', event.nativeEvent);
      }}
      onMenuDidHide={(event) => {
        console.log("onMenuDidHide");
        EventEmitterRef.current!.emit('onMenuDidHide', event.nativeEvent);
      }}
    >
      <ContextMenuCard
        index={props.index}
        title={'ContextMenuTest01'}
        description={[
          `TBA`
        ]}
      >
        <CardButton
          title={'Next Config Preset'}
          subtitle={`Preset Index: ${presetIndex} of ${ContextMenuConfigPresets.length - 1}`}
          onPress={() => {
            setPresetCounter(prevValue => prevValue + 1);
          }}
        />
        <CardButton
          title={'Start Auto Test'}
          subtitle={`Go through each test items...`}
          onPress={async () => {
            if(menuRef.current == null) return;
            if(EventEmitterRef.current == null) return;

            for(let index = 0; index < ContextMenuConfigPresets.length; index++){
              setPresetCounter(index);
              await Helpers.timeout(100);

              console.log("index:", index, "- showing menu...");

              // show menu...
              await Promise.all([
                menuRef.current!.presentMenu(),
                Helpers.promiseWithTimeout(1000, new Promise<void>(resolve => {
                  EventEmitterRef.current!.once('onMenuDidShow', () => {
                    resolve();
                  });
                })),
              ]);

              console.log("index:", index, "- wait...");
              
              // delay...
              await Helpers.timeout(300);

              console.log("index:", index, "- hiding menu...");

              // hide menu...
              await Promise.all([
                menuRef.current!.dismissMenu(),
                Helpers.promiseWithTimeout(1000, new Promise<void>(resolve => {
                  EventEmitterRef.current!.once('onMenuDidHide', () => {
                    resolve();
                  });
                })),
              ]);
            };
          }}
        />
      </ContextMenuCard>
    </ContextMenuView>
  );
};