#!/bin/bash

IOS_DIR_ITEMS=(
  "example/ios" 
  "ios"
)

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

# Filter only valid paths into IOS_DIR_PATHS
IOS_DIR_PATHS=()
for path in "${IOS_DIR_ITEMS[@]}"; do
  if [ -d "$path" ]; then
    IOS_DIR_PATHS+=("$path")
  fi
done


# Extract version from package.json
PACKAGE_VERSION=$(
  cat package.json | 
  grep version | 
  head -1 | 
  awk -F: '{ print $2 }' | 
  sed 's/[\",]//g' | 
  sed 's/-.*//'
)

# Navigate to each **/ios directory and update version
for ios_dir in "${IOS_DIR_PATHS[@]}"; do
  echo "Processing directory: $ios_dir"
  cd $ios_dir

  agvtool new-marketing-version $PACKAGE_VERSION

  # Increment the version number
  xcrun agvtool next-version -all

  echo "Version updated to $PACKAGE_VERSION"
done