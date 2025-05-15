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

printf "%s\n" "${IOS_DIR_PATHS[@]}"
