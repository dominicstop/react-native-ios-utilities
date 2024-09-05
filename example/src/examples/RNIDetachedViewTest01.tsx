/* eslint-disable react-native/no-inline-styles */
/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text, TouchableOpacity } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, Colors, RNIDetachedView, CardButton, type RNIDetachedViewRef, type AlignmentPositionConfig } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';


export function RNIDetachedViewTest01(props: ExampleItemProps) {
  const detachedViewRef = React.useRef<RNIDetachedViewRef | null>(null);
  
  const [didDetach, setDidDetach] = React.useState(false);
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

  const shouldFillParent = didDetach && (
       (counter % 5 === 0)
    || (counter % 6 === 0)
  );

  const shouldShowClearTimerButton = 
    (isIntervalRunning || counter > 0);

  const contentPositionConfig: AlignmentPositionConfig = {
    horizontalAlignment: 'stretchTarget',
    verticalAlignment: 'stretchTarget',
  };

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'RNIDetachedViewTest01'}
      description={[
        "TBA",
      ]}
    >
      <RNIDetachedView 
        ref={detachedViewRef}
        style={styles.detachedView}
        contentContainerStyle={[
          styles.detachedContentContainer,
          styles.detachedContentContainerDetached,
        ]}
        shouldEnableDebugBackgroundColors={false}
        onContentViewDidDetach={() => {
          setDidDetach(true);
        }}
      >
        <TouchableOpacity 
          style={[
            styles.counterContainer,
            shouldFillParent && styles.counterContainerLarge,
          ]}
          onPress={() => {
            // @ts-ignore
            // eslint-disable-next-line no-alert
            alert('onPress Event Triggered');
          }}
        >
          {(isCounterOdd && shouldDisplaySubtitle) && (
            <Text style={[
              styles.counterSubtitleLabel,
              !useAltCounterSubtitle && styles.counterSubtitleLabelAlt,
              shouldFillParent && styles.counterSubtitleLabelLarge,
            ]}>
              {'Odd'}
            </Text>
          )}
          <Text style={[
            styles.counterLabel,
            shouldFillParent && styles.counterLabelLarge,
          ]}>
            {counter}
          </Text>
          {(!isCounterOdd && shouldDisplaySubtitle) && (
            <Text style={[
              styles.counterSubtitleLabel,
              useAltCounterSubtitle && styles.counterSubtitleLabelAlt,
              shouldFillParent && styles.counterSubtitleLabelLarge,
            ]}>
              {'Even'}
            </Text>
          )}
        </TouchableOpacity>
      </RNIDetachedView>
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={{isIntervalRunning, ...contentPositionConfig}}
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
          detachedViewRef.current?.attachToWindow({
            contentPositionConfig,
          });
        }}
      />
      <CardButton
        title={'Present In View Controller'}
        subtitle={'Detach and present'}
        onPress={() => {
          detachedViewRef.current?.presentInModal();
        }}
      />
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  detachedView: {
  },
  detachedContentContainer: {
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