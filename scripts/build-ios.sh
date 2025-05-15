#!/bin/bash

ARG_BUILD_CONFIG="${1:-DEBUG}"

# `cd ./example/ios`
IOS_DIR_ITEMS=(
  "examples/example-core/ios"
  "example/ios"
  "ios"
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

WORKSPACE_FILE_NAME=$(
  find . -name "*.xcworkspace" | head -n 1
)

# Check if no file was found
if [ -z "$WORKSPACE_FILE_NAME" ]; then
  echo "Error: No *.xcworkspace file found"
  exit 1
fi

BUILD_INFO=$(
  xcodebuild \
    -project ./*.xcodeproj \
    -showBuildSettings -list -json | tr -d ' ' | tr -d '\n'
)

BUILD_CONFIG=""
if [ "$ARG_BUILD_CONFIG" == "DEBUG" ]; then
  BUILD_CONFIG="Debug"

elif [ "$ARG_BUILD_CONFIG" == "Debug" ]; then
  BUILD_CONFIG="Debug"

elif [ "$ARG_BUILD_CONFIG" == "RELEASE" ]; then
  BUILD_CONFIG="Release"

elif [ "$ARG_BUILD_CONFIG" == "Release" ]; then
  BUILD_CONFIG="Release"

else
  echo "Error: Unknown build configuration '$ARG_BUILD_CONFIG'. Please specify 'DEBUG' or 'RELEASE'."
  exit 1
fi

SCHEME_NAME=$(
  node -pe 'JSON.parse(process.argv[1]).project.schemes[0]' "$BUILD_INFO"
)

echo "Starting build..."
echo " - Workspace File: - $WORKSPACE_FILE_NAME"
echo " - Configuration: $ARG_BUILD_CONFIG"
echo " - Scheme: $SCHEME_NAME"

xcodebuild \
  -workspace *.xcworkspace \
  -configuration "$BUILD_CONFIG" \
  -scheme "$SCHEME_NAME" \
  -destination 'generic/platform=iOS' \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  clean build
