#!/bin/bash

IOS_DIR_ITEMS=(
  "example/ios" 
  "ios"
)

# set directory if needed
# `cd ./example/ios`
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

pod cache clean --all 
rm -rfv ./Pods ./build ./Podfile.lock 
