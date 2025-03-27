#!/bin/bash

# NOTE:
# * Running this script with yarn will produce the wrong path for node
# * This is used as a fallback
FALLBACK="export NODE_BINARY=\$(command -v node)"

cd example/ios
NODE_BINARY_PATH=$(command -v node)

IS_NODE_BINARY_PATH_BAD=0
BAD_NODE_BINARY_PATH_PREFIX="/private/var/"

# Check if the string contains "/private/var/folders/"
if [[ "$NODE_BINARY_PATH" == *"$BAD_NODE_BINARY_PATH_PREFIX"* ]]; then
  IS_NODE_BINARY_PATH_BAD=1
fi

echo "Writting: .xcode.env and .xcode.env.local"

if [ $IS_NODE_BINARY_PATH_BAD == 1 ]; then
  echo "Warning: NODE_BINARY path malformed: $NODE_BINARY_PATH"
  echo "Using fallback: $FALLBACK"
  echo "$FALLBACK" > .xcode.env
  echo "$FALLBACK" > .xcode.env.local
else
  FILE_CONTENTS="export NODE_BINARY=$NODE_BINARY_PATH"

  echo "Setting NODE_BINARY path: $NODE_BINARY_PATH"
  echo $FILE_CONTENTS > .xcode.env
  echo $FILE_CONTENTS > .xcode.env.local
fi
