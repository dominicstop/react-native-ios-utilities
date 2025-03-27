#!/bin/bash

# Extract version from package.json
PACKAGE_VERSION=$(
  cat package.json | 
  grep version | 
  head -1 | 
  awk -F: '{ print $2 }' | 
  sed 's/[\",]//g' | 
  sed 's/-.*//'
)

# Navigate to example/ios directory and update version
cd example/ios || exit
agvtool new-marketing-version $PACKAGE_VERSION

# Increment the version number
xcrun agvtool next-version -all

echo "Version updated to $PACKAGE_VERSION"
