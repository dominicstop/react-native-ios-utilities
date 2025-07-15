#!/bin/bash

LIB_ROOT_DIR_NAME="react-native-ios-utilities"

# CD to `LIB_ROOT_DIR_NAME`
goToLibRootIfNeeded() {
  CURRENT_DIR="$(pwd)"
  while [ "$(basename "$CURRENT_DIR")" != "$LIB_ROOT_DIR_NAME" ]; do
    if [ "$CURRENT_DIR" = "/" ]; then
      return 1
    fi
    CURRENT_DIR="$(dirname "$CURRENT_DIR")"
  done

  cd "$CURRENT_DIR" || return 1
  return 0
}

goToLibRootIfNeeded

IOS_DIR_ITEMS=()

# append all in: `examples/**/ios`
if [ -d "examples" ]; then
  for dir in examples/*/; do

    # skip if not a directory...
    [ -d "$dir" ] || continue

    # skip: examples/example-core/
    if [ "$dir" = "examples/example-core/" ]; then
      continue
    fi

    if [ -d "${dir}ios" ]; then
      IOS_DIR_ITEMS+=("${dir}ios")
    fi
  done
fi

IOS_DIR_ITEMS+=("example/ios")

# Filter only valid paths into IOS_DIR_PATHS
IOS_DIR_PATHS=()
for path in "${IOS_DIR_ITEMS[@]}"; do
  if [ -d "$path" ]; then
    IOS_DIR_PATHS+=("$path")
  fi
done

printf "%s\n" "${IOS_DIR_PATHS[@]}"
