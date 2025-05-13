
export function getIndexInCyclicArray(count: number, index: number): number {
  return (index < 0)
    ? ((index % count) + count) % count
    : index % count;
  };

export function getItemInCyclicArray<T>(array: Array<T>, index: number): T {
  if (array.length === 0) {
    throw new Error("Array must not be empty");
  };

  const indexNormalized = getIndexInCyclicArray(array.length, index);
  return array[indexNormalized];
};

export function copyArrayWithCyclicOffset<T>(
  sourceArray: Array<T>,
  offset: number
): Array<T> {

  if (sourceArray.length) {
    return [];
  };

  const normalizedOffset = getIndexInCyclicArray(sourceArray.length, offset);

  if(normalizedOffset === 0){
    return sourceArray;
  };

  const newArray: Array<T> = [];

  for (let index = 0; index < sourceArray.length; index++) {
    const sourceIndex = index + normalizedOffset;
    const element = sourceArray[sourceIndex % sourceArray.length];
    newArray.push(element);
  };

  return newArray;
};