#!/bin/bash

ARG_BUILD_CONFIG="${1:-DEBUG}"

cd ./example/ios

BUILD_INFO=$(
  xcodebuild \
    -project ./*.xcodeproj \
    -showBuildSettings -list -json | tr -d ' ' | tr -d '\n'
)

BUILD_CONFIG=""
if [ "$ARG_BUILD_CONFIG" == "DEBUG" ]; then
  BUILD_CONFIG="Debug"
elif [ "$ARG_BUILD_CONFIG" == "RELEASE" ]; then
  BUILD_CONFIG="Release"
else
  echo "Error: Unknown build configuration '$ARG_BUILD_CONFIG'. Please specify 'DEBUG' or 'RELEASE'."
  exit 1
fi

SCHEME_NAME=$(
  node -pe 'JSON.parse(process.argv[1]).project.schemes[0]' "$BUILD_INFO"
)

echo "Starting build..."
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
