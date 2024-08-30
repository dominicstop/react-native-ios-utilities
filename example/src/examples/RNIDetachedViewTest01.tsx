/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, Colors, RNIDetachedView, CardButton } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';


export function RNIDetachedViewTest01(props: ExampleItemProps) {
  const [isIntervalRunning, setIsIntervalRunning] = React.useState(false);
  const [counter, setCounter] = React.useState(0);
  
  const counterIntervalID = React.useRef<NodeJS.Timeout | undefined>();

  const stopTimer = () => {
    setIsIntervalRunning(false);

    clearInterval(counterIntervalID.current);
    counterIntervalID.current = undefined;
  };

  const startTimer = () => {
    stopTimer();

    counterIntervalID.current = setInterval(() => {
      setCounter(prevValue => prevValue + 1);
    }, 1500);

    setIsIntervalRunning(true);
  };

  const toggleTimer = () => {
    if(isIntervalRunning){
      stopTimer();

    } else {
      startTimer();
    };
  };

  React.useEffect(() => {
    startTimer();

    return () => {
      stopTimer();
    };
  }, []);

  const isCounterOdd = (counter % 2 !== 0);
  const shouldDisplaySubtitle = (counter % 3 !== 0);
  const useAltCounterSubtitle = (counter % 4 !== 0);

  const shouldShowClearTimerButton = 
    (isIntervalRunning || counter > 0);

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'RNIDetachedViewTest01'}
      description={[
        "TBA",
      ]}
    >
      <RNIDetachedView style={styles.detachedView}>
        {(isCounterOdd && shouldDisplaySubtitle) && (
          <Text style={[
            styles.counterSubtitleLabel,
            !useAltCounterSubtitle && styles.counterSubtitleLabelAlt,
          ]}>
            {'Odd'}
          </Text>
        )}
        <Text style={styles.counterLabel}>
          {counter}
        </Text>
        {(!isCounterOdd && shouldDisplaySubtitle) && (
          <Text style={[
            styles.counterSubtitleLabel,
            useAltCounterSubtitle && styles.counterSubtitleLabelAlt,
          ]}>
            {'Even'}
          </Text>
        )}
      </RNIDetachedView>
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={{isIntervalRunning}}
      />
      <CardButton
        title={`${isIntervalRunning ? 'Pause' : 'Resume'} Timer`}
        subtitle={'Toggle the current interval timer state'}
        onPress={() => {
          toggleTimer();
        }}
      />
      {shouldShowClearTimerButton && (
        <CardButton
          title={`Clear Counter`}
          subtitle={'Reset the counter back to 0'}
          onPress={() => {
            setCounter(0);
          }}
        />
      ) as any}
      <CardButton
        title={'Attach To Window'}
        subtitle={'Detach and attach to window'}
        onPress={() => {
        }}
      />
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  detachedView: {
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(255,255,255,0.3)',
    borderRadius: 10,
    marginTop: 12,
    paddingHorizontal: 15,
    paddingVertical: 15
  },
  counterLabel: {
    fontSize: 24,
    fontWeight: '900',
    color: 'rgba(0,0,0,0.5)',
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
  debugDisplayInner: {
    backgroundColor: `${Colors.PURPLE[200]}99`,
  },
});