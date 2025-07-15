/* eslint-disable react-native/no-inline-styles */
/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, Colors } from 'react-native-ios-utilities';
import type { ExampleItemProps } from '../SharedExampleTypes';
import { AppMetadataCardContext } from './AppMetadataCardContext';

export type AppMetadataCardProps = ExampleItemProps & {
  metadataOverrideData?: Record<string, unknown>;
};

export function AppMetadataCard(props: AppMetadataCardProps) {
  const context = React.useContext(AppMetadataCardContext);

  const metadata = {
    ...(props.metadataOverrideData ?? {}),
    ...(context?.metadataOverrideData ?? {}),
  };
  
  
  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'App Metadata'}
    >
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={metadata}
      />
    </ExampleItemCard>
  );
}
const styles = StyleSheet.create({
  detachedView: {
  },
  detachedContentContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  detachedContentContainerDetached: {
  },
  counterContainer: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(255,255,255,0.3)',
    borderRadius: 10,
    marginTop: 12,
    paddingHorizontal: 15,
    paddingVertical: 15
  },
  counterContainerLarge: {
    flex: 1,
    alignSelf: 'stretch',
    marginHorizontal: 24,
    marginBottom: 32,
    marginTop: 52,
    borderRadius: 40,
  },
  counterLabel: {
    fontSize: 24,
    fontWeight: '900',
    color: 'rgba(0,0,0,0.5)',
  },
  counterLabelLarge: {
    fontSize: 64,
  },
  counterSubtitleLabel: {
    fontSize: 16,
    color: 'rgba(0,0,0,0.7)',
    fontWeight: '400',
  },
  counterSubtitleLabelAlt: {
    fontSize: 18,
    marginVertical: 4,
    fontWeight: '600',
    color: 'rgba(0,0,0,0.5)',
  },
  counterSubtitleLabelLarge: {
    fontSize: 32,
  },
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
});