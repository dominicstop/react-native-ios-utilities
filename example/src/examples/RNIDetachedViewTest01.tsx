/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text, TouchableOpacity } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, Colors, RNIDetachedView, RNIDetachedViewContent, CardButton, type RNIDetachedViewRef, type AlignmentPositionConfig, type RNIDetachedViewProps } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';

var shouldImmediatelyDetachCached = false;

export function RNIDetachedViewTest01(props: ExampleItemProps) {
  const detachedViewRef = React.useRef<RNIDetachedViewRef | null>(null);

  const [didDetach, setDidDetach] = React.useState(false);
  
  const [
    shouldImmediatelyDetach, 
    setShouldImmediatelyDetach
  ] = React.useState(shouldImmediatelyDetachCached);

  const [mountDetachedView, setMountDetachedView] = React.useState(true);

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

  const detachedViewProps: RNIDetachedViewProps = {
    shouldEnableDebugBackgroundColors: false,
    shouldImmediatelyDetach,
  };

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'RNIDetachedViewTest01'}
      description={[
        "Simple test for detaching a react view from it's parent (for use in other native views)",
        "View should be centered and resize (grow/shrink)",
      ]}
    >
      {mountDetachedView && (
        <RNIDetachedView 
          ref={detachedViewRef}
          style={styles.detachedView}
          {...detachedViewProps}
          onContentViewDidDetach={() => {
            setDidDetach(true);
          }}
        >
          <RNIDetachedViewContent
            contentContainerStyle={[
              styles.detachedContentContainer,
              styles.detachedContentContainerDetached,
            ]}
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
          </RNIDetachedViewContent>
        </RNIDetachedView>
      )}
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={{
          isIntervalRunning,
          didDetach, 
          mountDetachedView,
          shouldFillParent,
          contentPositionConfig,
          detachedViewProps,
        }}
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
      <CardButton
        title={`${mountDetachedView ? 'Unmount' : 'Mount'} WrapperView`}
        subtitle={'Toggle mounting for `RNIDetachedView` component'}
        onPress={() => {
          setMountDetachedView(prevValue => !prevValue);
          setDidDetach(false);
        }}
      />
      <CardButton
        title={`Toggle shouldImmediatelyDetach Prop`}
        subtitle={`shouldImmediatelyDetach: ${shouldImmediatelyDetach}`}
        onPress={() => {
          const nextValue = !shouldImmediatelyDetach;
          setShouldImmediatelyDetach(nextValue);
          shouldImmediatelyDetachCached = nextValue;
        }}
      />
    </ExampleItemCard>
  );
};

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