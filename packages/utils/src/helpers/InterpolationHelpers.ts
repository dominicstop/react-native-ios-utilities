

export function lerp(
  valueStart: number,
  valueEnd: number,
  percent: number
): number {

  let deltaRange = valueEnd - valueStart;
  let totalChange = deltaRange * percent;
  
  let interpolatedValue = valueStart + totalChange;
  return interpolatedValue;
};

/**
* solve for `percent`, given: `valueStart`, `valueEnd`, `interpolatedValue`
*
* lerp formula, solve for `p`
* ```
* iv = vs + p * (vs - ve)
* iv - vs = p * (vs - ve)
* (iv - vs) / (vs - ve) = p
* ```
*/
export function inverseLerp(
  valueStart: number,
  valueEnd: number,
  interpolatedValue: number
): number {

  const deltaChange = interpolatedValue - valueStart;
  const deltaRange = valueEnd - valueStart;
  
  const changePercent = deltaChange / deltaRange;
  return changePercent;
};

export function rangedLerpUsingInputValue(
  inputValue: number,
  inputValueStart: number,
  inputValueEnd: number,
  outputValueStart: number,
  outputValueEnd: number,
): number {

  const inputValueAdj   = inputValue    - inputValueStart;
  const inputRangeDelta = inputValueEnd - inputValueStart;

  const progressRaw = inputValueAdj / inputRangeDelta;
  const progress = Number.isFinite(progressRaw) ? progressRaw : 0;

  return lerp(
    /* valueStart: */ outputValueStart,
    /* valueEnd  : */ outputValueEnd,
    /* percent   : */ progress
  );
};

export function rangedLerpUsingRelativePercent(
  relativePercent: number,
  inputValueStart: number,
  inputValueEnd: number,
  outputValueStart: number,
  outputValueEnd: number
): number {
  
  const rangeDelta = Math.abs(inputValueStart - inputValueEnd);
  const inputValue = rangeDelta * relativePercent;
  
  const percentRaw = inputValue / rangeDelta;
  const percent = Number.isFinite(percentRaw) ? percentRaw : 0;
  
  return lerp(
    /* valueStart: */ outputValueStart,
    /* valueEnd  : */ outputValueEnd,
    /* percent   : */ percent
  );
};

export function rangedLerpUsingArray(
  inputValue: number,
  rangeInput: Array<number>,
  rangeOutput: Array<number>,
  shouldClampMin: boolean = false,
  shouldClampMax: boolean = false
): number | undefined {

  if(
       rangeInput.length != rangeOutput.length
    || rangeInput.length <= 2
  ){
    return;
  };

  if(shouldClampMin && inputValue < rangeInput[0] ){
    return rangeInput[0];
  };

  if(shouldClampMax && inputValue < rangeInput.slice(-1)[0]){
    return rangeInput.pop();
  };
  
  // A - Extrapolate Left
  if(inputValue < rangeInput[0]){
    const rangeInputStart  = rangeInput[0];
    const rangeInputEnd = rangeInput[1];
    
    const rangeOutputStart = rangeOutput[0];
    const rangeOutputEnd = rangeOutput[1];

    return rangedLerpUsingInputValue(
      /* inputValue:       */ inputValue,
      /* inputValueStart:  */ rangeInputEnd,
      /* inputValueEnd:    */ rangeInputStart,
      /* outputValueStart: */ rangeOutputEnd,
      /* outputValueEnd:   */ rangeOutputStart
    );
  };

  const [rangeStartIndex, rangeEndIndex] = (() => {
    const matchIndex = rangeInput.findIndex((currentValue, index) => {
      const nextValue = rangeInput[index + 1];
      if(nextValue == null){
        return false;
      };
      
      return inputValue >= currentValue && inputValue < nextValue;
    });

    // B - Interpolate Between
    if(matchIndex != null){
      return [matchIndex, matchIndex + 1];
    };

    const lastIndex         = rangeInput.length - 1;
    const secondToLastIndex = rangeInput.length - 2;
    
    // C - Extrapolate Right
    return [secondToLastIndex, lastIndex];
  })();

  const rangeInputStart = rangeInput[rangeStartIndex];
  if(rangeInputStart == null){
    return;
  };

  const rangeInputEnd = rangeInput[rangeEndIndex];
  if(rangeInputEnd == null){
    return;
  };

  const rangeOutputStart = rangeOutput[rangeStartIndex];
  if(rangeOutputStart == null){
    return;
  };

  const rangeOutputEnd = rangeOutput[rangeEndIndex];
  if(rangeOutputEnd == null){
    return;
  };
  
  return rangedLerpUsingInputValue(
    /* inputValue      : */ inputValue,
    /* inputValueStart : */ rangeInputStart,
    /* inputValueEnd   : */ rangeInputEnd,
    /* outputValueStart: */ rangeOutputStart,
    /* outputValueEnd  : */ rangeOutputEnd
  );
};