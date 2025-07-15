#!/bin/bash

# NOTE:
# * Running this script with yarn will produce the wrong path for node
# * This is used as a fallback
FALLBACK="export NODE_BINARY=\$(command -v node)"

# `cd ./example/ios`
IOS_DIR_ITEMS=(
  "ios"
  "examples/example-core/ios"
)

# set directory if needed
if [ -d "ios" ]; then
  for directory in "${IOS_DIR_ITEMS[@]}"; do
    if [ -d "$directory" ]; then
      cd "$directory"
      echo "Current DIR: $(pwd)"
      echo "Changed directory to: $directory"
      break
    fi
  done
fi

NODE_BINARY_PATH=$(command -v node)

IS_NODE_BINARY_PATH_BAD=0
BAD_NODE_BINARY_PATH_PREFIX="/private/var/"

# Check if the string contains "/private/var/folders/"
if [[ "$NODE_BINARY_PATH" == *"$BAD_NODE_BINARY_PATH_PREFIX"* ]]; then
  IS_NODE_BINARY_PATH_BAD=1
fi

echo "Writting: .xcode.env and .xcode.env.local"

IS_NVM_INSTALLED=0
NVM_DIR="$HOME/.nvm"

# try load NVM
if [ $IS_NODE_BINARY_PATH_BAD == 1 ]; then
  echo "Warning: NODE_BINARY path malformed: $NODE_BINARY_PATH"
  echo "Task: Checking if NVM installed..."

  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck source=/dev/null
    \. "$NVM_DIR/nvm.sh"
    IS_NVM_INSTALLED=1

    echo "Task: NVM loaded successfully."
    echo "Task: NVM - Installing stable..."
    nvm install stable

    echo "Task: NVM - Setting node version to stable..."
    nvm use stable

    NODE_BINARY_PATH=$(nvm which stable)
    echo "Using NVM for NODE_BINARY_PATH: $NODE_BINARY_PATH"
  fi

else
  echo "Status: NODE_BINARY_PATH not malformed"
fi

if [[ $IS_NODE_BINARY_PATH_BAD == 1 && $IS_NVM_INSTALLED == 0 ]]; then
  echo "Warning: NVM not found..."
  echo "Using fallback: $FALLBACK"
  echo "$FALLBACK" > .xcode.env
  echo "$FALLBACK" > .xcode.env.local

else
  FILE_CONTENTS="export NODE_BINARY=$NODE_BINARY_PATH"

  echo "Setting NODE_BINARY path: $NODE_BINARY_PATH"
  echo $FILE_CONTENTS > .xcode.env
  echo $FILE_CONTENTS > .xcode.env.local
fi
