import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { RNIDetachedView, RNIImageView, RNIImageViewModule } from 'react-native-ios-utilities';

import type { ExampleItemProps } from '../SharedExampleTypes';
import { ExampleItemCard } from '../../components/ExampleItemCard';
import { CardButton } from '../../components/Card';


export function RNIImageViewTest01(props: ExampleItemProps) {
  const [counter, setCounter] = React.useState(0);
  const [symbolsList, setSymbolsList] = React.useState<Array<string>>([]);

  const symbolsListCount = symbolsList.length;
  const currentSymbolListIndex = counter % symbolsListCount;

  const currentSymbolListItem = symbolsList?.[counter] ?? 'star';

  React.useEffect(() => {
    const getSymbols = async () => {
      const result = await RNIImageViewModule.getAllSFSymbols();
      const keys = Object.keys(result);
      setSymbolsList(keys);
    };

    getSymbols();
  }, []);

  const [
    shouldMountDetachedView,
    setShouldMountDetachedView
  ] = React.useState(true);
  
  return (
    <ExampleItemCard  
      style={props.style}
      index={props.index}
      title={'RNIImageViewTest01'}
      subtitle={'RNIImageMaker'}
      description={[
        `This is a test for 'RNIImageMaker' config.`,
      ]}
    >
      <RNIImageView
        style={{
          height: 100, 
          width: 100,
          backgroundColor: 'red'
        }}
        imageConfig={{
          type: 'IMAGE_SYSTEM',
          imageValue: {
            systemName: currentSymbolListItem,
          },
        }}
        preferredSymbolConfiguration={{
          imageSymbolConfigItems: [{
            pointSize: 100,
          }, {
            weight: 'bold',
          }, {
            paletteColors: ['orange', 'green'],
          }],
        }}
      />
      <CardButton
        title={'Next Icon'}
        subtitle={`Index: ${currentSymbolListIndex} of ${symbolsListCount - 1}`}
        onPress={() => {
          setCounter(prevValue => prevValue + 1);
        }}
      />
  </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  detachedViewContent: {
    width: 250,
    height: 250,
    alignSelf: 'stretch',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'red',
  },
});
