import * as React from 'react';
import { StyleSheet, View, Text, type ViewStyle, type TextStyle, type StyleProp } from 'react-native';

import { Colors } from '../misc/Colors';

/**
 * ```
 * ┌─────────────────────────────┐
 * │ Property            'Value' │
 * │ Object                      │
 * │  Property           'Value' │
 * │  Property           'Value' │
 * └─────────────────────────────┘
 * ```
 */                               
export function ObjectPropertyDisplay<T extends {}>(props: {
  object?: T;
  style?: StyleProp<ViewStyle>; 
  recursiveStyle?: StyleProp<ViewStyle>;
  propertyLabelTextStyle?: TextStyle;
  propertyValueTextStyle?: TextStyle;
  emptyObjectText?: TextStyle;
}){

  const hasObject = props.object != null;

  const objectKeys = (hasObject
    ? Object.keys(props.object!)
    : []
  ) as Array<keyof T>;

  return hasObject? (
    <View style={[
      styles.rootContainerBase, 
      styles.rootContainerWhenHasObject,
      props.recursiveStyle,
      props.style,
    ]}>
      {objectKeys.map((objKeyRaw, index) => {
        const objKey = String(objKeyRaw);
        const value = props.object![objKeyRaw];
        const isValueObj = (typeof value === 'object' && value !== null);

        return isValueObj?(
          <View key={`container-${objKey}-${index}`}>
            <Text 
              key={`label-${objKey}-${index}`}
              style={[
                styles.propertyLabelText, 
                styles.propertyLabelObjectText,
                props.propertyLabelTextStyle
              ]}
            >
              {`${objKey}: `}
            </Text>
            <ObjectPropertyDisplay
              key={`value-ObjectPropertyDisplay-${objKey}-${index}`}
              object={value!}
              recursiveStyle={[
                styles.objectPropertyDisplay,
                props.recursiveStyle
              ]}
              propertyLabelTextStyle={props.propertyLabelTextStyle}
              propertyValueTextStyle={props.propertyValueTextStyle}
            />
          </View>
        ):(
          <View 
            key={`container-${objKey}-${index}`}
            style={styles.rowContainer}
          >
            <Text 
              key={`label-${objKey}-${index}`}
              style={[
                styles.propertyLabelText,
                props.propertyLabelTextStyle
              ]}
            >
              {`${objKey}: `}
            </Text>
            <Text 
              key={`value-${objKey}-${index}`}
              style={[
                styles.propertyValueText,
                props.propertyValueTextStyle
              ]}
            >
              {isValueObj? `...`: `'${props.object![objKeyRaw]}'`}
            </Text>
          </View>
        );
      })}
    </View>
  ):(
    <View style={[
      styles.rootContainerBase, 
      styles.rootContainerWhenEmptyObject, 
      props.recursiveStyle
    ]}>
      <Text style={[
        styles.emptyObjectText,
        props.emptyObjectText
      ]}>
        {'Nothing to show'}
      </Text>
    </View>
  );
};

const styles = StyleSheet.create({
  rootContainerBase: {
    marginTop: 12,
    paddingHorizontal: 12,
    paddingVertical: 12,
    backgroundColor: Colors.INDIGO[100],
    borderRadius: 10,
  },
  rootContainerWhenEmptyObject: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  rootContainerWhenHasObject: {
    flexDirection: 'column',
    paddingVertical: 5,
  },
  propertyLabelText: {
    flex: 1,
    fontSize: 12,
    fontWeight: '400',
    color: Colors.PURPLE[1100],
    opacity: 0.8,
  },
  propertyLabelObjectText: {
    flex: 0,
  },
  propertyValueText: {
    fontSize: 12,
    fontWeight: '300',
    color: Colors.PURPLE[1100],
    opacity: 0.6,
  },
  objectPropertyDisplay: {
    marginTop: 6,
    marginBottom: 6,
    paddingHorizontal: 7,
    paddingVertical: 5,
  },
  rowContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  emptyObjectText: {
    opacity: 0.75
  },
});