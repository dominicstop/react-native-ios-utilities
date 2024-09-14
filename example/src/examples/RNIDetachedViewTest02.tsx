/* eslint-disable react-hooks/exhaustive-deps */
import * as React from 'react';
import { StyleSheet, Text, TouchableOpacity, type ViewStyle } from 'react-native';

import { ExampleItemCard, ObjectPropertyDisplay, Colors, RNIDetachedView, RNIDetachedViewContent, CardButton, type RNIDetachedViewRef, type AlignmentPositionConfig, type RNIDetachedViewProps, Helpers } from 'react-native-ios-utilities';
import type { ExampleItemProps } from './SharedExampleTypes';


const CONTENT_POSITION_CONFIG_PRESETS: Array<{
  desc?: string;
  config: AlignmentPositionConfig;
  style?: ViewStyle;
}> = [
  // tests 01: as big as possible
  {
    desc: "Stretch and fill",
    config: {
      horizontalAlignment: 'stretch',
      verticalAlignment: 'stretch',
    },
  },

  // tests 02: no specified size, centered
  {
    desc: "Attach to center (no specified size)",
    config: {
      horizontalAlignment: 'targetCenter',
      verticalAlignment: 'targetCenter',
    },
  },
  {
    desc: "Attach to center top (no specified size)",
    config: {
      horizontalAlignment: 'targetCenter',
      verticalAlignment: 'targetTop',
    },
  },
  {
    desc: "Attach to center left (no specified size)",
    config: {
      horizontalAlignment: 'targetLeading',
      verticalAlignment: 'targetCenter',
    },
  },
  {
    desc: "Attach to center right (no specified size)",
    config: {
      horizontalAlignment: 'targetTrailing',
      verticalAlignment: 'targetCenter',
    },
  },
  {
    desc: "Attach to center bottom (no specified size)",
    config: {
      horizontalAlignment: 'targetCenter',
      verticalAlignment: 'targetBottom',
    },
  },

  // tests 03: no specified size + fill width 
  // * Mixed sizing, i.e. one of the sizes (either width/height) is set on 
  //  native, and the other is set in react/JS

  // Observations (paper):
  // * 2024-09-14-23:32 (PST) 
  //   * the view jumps around, but eventually settles
  //   * Because autolayout doesn't know the size of the react view yet, and/or
  //     the size from autolayout/native isn't set yet. 
  {
    desc: "Attach to top, and fill width (no specified size)",
    config: {
      horizontalAlignment: 'stretch',
      verticalAlignment: 'targetTop',
    },
  },
  {
    desc: "Attach to center, and fill width (no specified size)",
    config: {
      horizontalAlignment: 'stretch',
      verticalAlignment: 'targetCenter',
    },
  },
  {
    desc: "Attach to bottom, and fill width (no specified size)",
    config: {
      horizontalAlignment: 'stretch',
      verticalAlignment: 'targetBottom',
    },
  },

  // tests 04: no specified size + fill height
  {
    desc: "Attach to left, and fill height (no specified size)",
    config: {
      horizontalAlignment: 'targetLeading',
      verticalAlignment: 'stretch',
    },
  },
  {
    desc: "Attach to center, and fill height (no specified size)",
    config: {
      horizontalAlignment: 'targetCenter',
      verticalAlignment: 'stretch',
    },
  },
  {
    desc: "Attach to right, and fill height (no specified size)",
    config: {
      horizontalAlignment: 'targetTrailing',
      verticalAlignment: 'stretch',
    },
  },
  
  // fixed size
  // TBA
];


export function RNIDetachedViewTest02(props: ExampleItemProps) {
  const detachedViewRef = React.useRef<RNIDetachedViewRef | null>(null);

  const [didPresent, setDidPresent] = React.useState(false);
  const [didDetach, setDidDetach] = React.useState(false);
  const [mountDetachedView, setMountDetachedView] = React.useState(true);

  const [isIntervalRunning, setIsIntervalRunning] = React.useState(false);
  const [counter, setCounter] = React.useState(0);

  const [
    contentPositionConfigPresetCounter, 
    setContentPositionConfigPresetCounter
  ] = React.useState(0);

  const contentPositionConfigPresetIndex = 
    contentPositionConfigPresetCounter % CONTENT_POSITION_CONFIG_PRESETS.length;

  const { 
    desc: contentPositionConfigDesc, 
    config: contentPositionConfig,
    style: extraStyle
  } = CONTENT_POSITION_CONFIG_PRESETS[contentPositionConfigPresetIndex]!;
  
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

  const detachedViewProps: RNIDetachedViewProps = {
    shouldEnableDebugBackgroundColors: true,
    shouldImmediatelyDetach: true,
  };

  const onRenderCallbackRef = React.useRef<() => void | undefined>();

  React.useEffect(() => {
    onRenderCallbackRef.current?.();
  });

  const remountDetachedView = async () => {
    if(!mountDetachedView) return;
    setMountDetachedView(false);
    setDidDetach(false);
    setDidPresent(false);

    await Promise.race([
      new Promise<void>((resolve) => {
        onRenderCallbackRef.current = () => {
          resolve();
        };
      }),
      Helpers.timeout(250),
    ]);

    setMountDetachedView(true);
  };

  const remountDetachedViewIfNeeded = () => {
    if(!didPresent) return;
    setDidPresent(false);
    remountDetachedView();
  };

  return (
    <ExampleItemCard
      style={props.style}
      index={props.index}
      title={'RNIDetachedViewTest02'}
      description={[
        "TBA",
        contentPositionConfigDesc && (
            "\nPreset Desc: " 
          + contentPositionConfigDesc
        ),
      ]}
    >
      {mountDetachedView && (
        <RNIDetachedView 
          ref={detachedViewRef}
          style={[
            styles.detachedView,
            extraStyle,
          ]}
          {...detachedViewProps}
          onContentViewDidDetach={() => {
            setDidDetach(true);
          }}
        >
          <RNIDetachedViewContent
            style={styles.detachedContent}
          >
            <TouchableOpacity 
              style={styles.counterContainer}
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
            </TouchableOpacity>
          </RNIDetachedViewContent>
        </RNIDetachedView>
      )}
      <ObjectPropertyDisplay
        recursiveStyle={styles.debugDisplayInner}
        object={{
          didPresent,
          isIntervalRunning,
          didDetach, 
          mountDetachedView,
          contentPositionConfigPresetIndex,
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
          setDidPresent(true);
        }}
      />
      <CardButton
        title={'Present In View Controller'}
        subtitle={'Detach and present'}
        onPress={() => {
          detachedViewRef.current?.presentInModal({
            contentPositionConfig,
          });
          setDidPresent(true);
        }}
      />
      {(didPresent) && (
        <CardButton
          title={`Remount RNIDetachedView`}
          subtitle={'Toggle mounting for `RNIDetachedView` component'}
          onPress={() => {
            remountDetachedView();
          }}
        />
      )}
      <CardButton
        title={"Next `ContentPositionConfig`"}
        subtitle={
            `Preset ${contentPositionConfigPresetIndex +1}`
          + ` of ${CONTENT_POSITION_CONFIG_PRESETS.length}`
        }
        onPress={() => {
          setContentPositionConfigPresetCounter(prevValue => prevValue + 1);
          remountDetachedViewIfNeeded();
        }}
      />
    </ExampleItemCard>
  );
};

const styles = StyleSheet.create({
  detachedView: {
  },
  detachedContent: {
  },
  counterContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(255,255,255,0.3)',
    padding: 24,
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