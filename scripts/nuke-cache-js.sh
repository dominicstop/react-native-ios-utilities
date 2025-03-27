#!/bin/bash

echo "Clearing RN/JS-Related Caches..."

# Clear Watchman Watches
watchman watch-del-all

# Remove temporary files and caches
rm -rfv $TMPDIR/react-*
rm -rfv $TMPDIR/react-native-packager-cache-*
rm -rfv $TMPDIR/metro-bundler-cache-*
rm -rfv $TMPDIR/haste-map-*
rm -rfv $TMPDIR/metro-cache

# Clean npm cache
npm cache clean --force
npm cache verify

# Clean yarn cache
yarn cache clean

# Remove yarn berry cache
rm -rfv ~/.yarn/berry/cache

echo "Cache cleaning complete!"
