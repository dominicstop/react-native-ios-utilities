import * as React from 'react';

import { ReactNativeIosUtilitiesViewProps } from './ReactNativeIosUtilities.types';

export default function ReactNativeIosUtilitiesView(props: ReactNativeIosUtilitiesViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
