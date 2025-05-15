#!/bin/bash

IOS_DIR_ITEMS=()

# append all in: `examples/**/ios`
if [ -d "examples" ]; then
  for dir in examples/*/; do

    # skip if not a directory...
    [ -d "$dir" ] || continue 

    if [ -d "${dir}ios" ]; then
      IOS_DIR_ITEMS+=("${dir}ios")
    fi
  done
fi

IOS_DIR_ITEMS+=("example/ios" "ios")

# Filter only valid paths into IOS_DIR_PATHS
IOS_DIR_PATHS=()
for path in "${IOS_DIR_ITEMS[@]}"; do
  if [ -d "$path" ]; then
    IOS_DIR_PATHS+=("$path")
  fi
done

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

# Navigate to each **/ios directory and update version
for ios_dir in "${IOS_DIR_PATHS[@]}"; do
  echo "Processing directory: $ios_dir"
  cd $ios_dir

  pod cache clean --all 
  rm -rfv ./Pods ./build ./Podfile.lock 
done

