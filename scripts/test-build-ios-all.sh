#!/bin/bash

# value: either "quick" or "not-quick"
# default: "quick"
BUILD_MODE="${1:-quick}"

LIB_ROOT_DIR_NAME="react-native-ios-utilities"
LIB_ROOT_DIR=$(pwd)

checkIfAtRootLibDirectory() {
  CURRENT_DIR="$(pwd)"
  CURRENT_DIR_FOLDER_NAME="$(basename "$CURRENT_DIR")"

  if [ "$CURRENT_DIR_FOLDER_NAME" = "$LIB_ROOT_DIR_NAME" ]; then
    return 0
  else
    return 1
  fi
}

# CD to `LIB_ROOT_DIR_NAME`
goToLibRootIfNeeded() {
  echo "Task: Navigating to library root..."

  if checkIfAtRootLibDirectory; then
    echo "Task: Already at library root!"
    return 0
  fi

  CURRENT_DIR="$(pwd)"
  echo "Task - CWD: $CURRENT_DIR"

  while [ "$(basename "$CURRENT_DIR")" != "$LIB_ROOT_DIR_NAME" ]; do
    if [ "$CURRENT_DIR" = "/" ]; then
      return 1
    fi
    CURRENT_DIR="$(dirname "$CURRENT_DIR")"
  done

  cd "$CURRENT_DIR" || return 1

  echo "Task - Navigated to library root: $CURRENT_DIR"
  LIB_ROOT_DIR=$CURRENT_DIR
  return 0
}

# go to lib root first
goToLibRootIfNeeded
echo "\n"

EXAMPLE_IOS_DIR_PATHS=""
setPathsForExampleIosDirs() {
  echo "Task: Getting all example/ios paths..."

  if [ ! -f ./scripts/test-build-ios-all.sh ]; then
    echo "Task: Error - Unable to get all example/ios paths. Exiting..."
    exit 1
  fi

  EXAMPLE_IOS_DIR_PATHS=$(sh ./scripts/echo-all-example-ios-paths.sh)

  if [ -z "$EXAMPLE_IOS_DIR_PATHS" ]; then
    echo "Task: Error - No example iOS directories found. Exiting..."
    exit 1
  fi

  echo "Task: Found all example/ios paths!"
  echo "EXAMPLE_IOS_DIR_PATHS:"
  echo $EXAMPLE_IOS_DIR_PATHS
}

setPathsForExampleIosDirs
echo "\n"


BUILD_CURRENT_PATH=""
BUILD_LOG=""
BUILD_LOG_COUNTER=0

run_tests(){
  NEW_ARCH_STATIC_DEBUG=PENDING
  OLD_ARCH_STATIC_DEBUG=PENDING
  NEW_ARCH_STATIC_RELEASE=PENDING
  OLD_ARCH_STATIC_RELEASE=PENDING
  # NEW_ARCH_DYNAMIC=PENDING
  OLD_ARCH_DYNAMIC=PENDING

  BUILD_STATUS=""

  set_build_status() {
    BUILD_STATUS=""
    BUILD_STATUS+="BUILD_CURRENT_PATH: $BUILD_CURRENT_PATH"
    BUILD_STATUS+="\nBUILD_MODE: $BUILD_MODE"
    BUILD_STATUS+="\nBuild - NEW_ARCH_STATIC_DEBUG: ${NEW_ARCH_STATIC_DEBUG}"
    BUILD_STATUS+="\nBuild - OLD_ARCH_STATIC_DEBUG: ${OLD_ARCH_STATIC_DEBUG}"
    BUILD_STATUS+="\nBuild - NEW_ARCH_STATIC_RELEASE: ${NEW_ARCH_STATIC_RELEASE}"
    BUILD_STATUS+="\nBuild - OLD_ARCH_STATIC_RELEASE: ${OLD_ARCH_STATIC_RELEASE}"
    # BUILD_LOG+="\nBuild - NEW_ARCH_DYNAMIC: ${NEW_ARCH_DYNAMIC}"
    BUILD_STATUS+="\nBuild - OLD_ARCH_DYNAMIC: ${OLD_ARCH_DYNAMIC}"
  }

  log_build_status(){
    set_build_status

    echo "\n\n"
    echo "CURRENT BUILD RESULTS:"
    echo $BUILD_STATUS
    echo "\n\n"
  }

  append_build_status_to_build_log(){
    set_build_status

    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

    BUILD_LOG+="\nBuild Results #$BUILD_LOG_COUNTER"
    BUILD_LOG+="\nTimestamp: $TIMESTAMP"
    BUILD_LOG+="\n"
    BUILD_LOG+=$BUILD_STATUS
    BUILD_LOG+="\n"

    # inc
    BUILD_LOG_COUNTER=$((BUILD_LOG_COUNTER + 1))
  }

  clear_cache_if_needed(){
    echo "\nBUILD_MODE: $BUILD_MODE"

    # Check the value of BUILD_MODE
    if [ "$BUILD_MODE" = "quick" ]; then
      echo "Skipping cleanup..."

    elif [ "$BUILD_MODE" = "not-quick" ]; then
      echo 'Task - Clearing pods + derived data...'
      yarn run nuke:example-pods
      yarn run nuke:derived-data
    else
      echo "Invalid BUILD_MODE. Please use 'quick' or 'not-quick'."
    fi
  }

  build_A1(){
    log_build_status
    clear_cache_if_needed

    echo '\nBuild - new-arch (fabric) + static, debug: Begin...\n'
    yarn run pod-install:new-static
    yarn run build:ios

    if [ $? -eq 0 ]; then
      NEW_ARCH_STATIC_DEBUG=SUCCESS;
    else
      NEW_ARCH_STATIC_DEBUG=FAILED;
    fi
  }

  build_A2(){
    log_build_status
    clear_cache_if_needed

    echo '\nBuild - old-arch (paper) + static, debug: Begin...'
    yarn run pod-install:old-static
    yarn run build:ios

    if [ $? -eq 0 ]; then
      OLD_ARCH_STATIC_DEBUG=SUCCESS;
    else
      OLD_ARCH_STATIC_DEBUG=FAILED;
    fi
  }

  build_B1(){
    log_build_status
    clear_cache_if_needed

    echo '\nBuild - new-arch (fabric) + static, release: Begin...'
    yarn run pod-install:new-static
    yarn run build:ios-release ;

    if [ $? -eq 0 ]; then
      NEW_ARCH_STATIC_RELEASE=SUCCESS;
    else
      NEW_ARCH_STATIC_RELEASE=FAILED;
    fi
  }

  build_B2(){
    log_build_status
    clear_cache_if_needed

    echo '\nBuild - old-arch (paper) + static, release: Begin...'
    yarn run pod-install:old-static
    yarn run build:ios-release ;

    if [ $? -eq 0 ]; then
      OLD_ARCH_STATIC_RELEASE=SUCCESS;
    else
      OLD_ARCH_STATIC_RELEASE=FAILED;
    fi
  }

  # build_C1(){
  # log_build_status
  # clear_cache_if_needed

  # echo '\nBuild - new-arch (fabric) + dynamic: Begin...\n'
  # yarn run pod-install:new-dynamic
  # yarn run build:ios

  # if [ $? -eq 0 ]; then
  #   NEW_ARCH_DYNAMIC=SUCCESS;
  # else
  #   NEW_ARCH_DYNAMIC=FAILED;
  # fi
  # }

  build_C2(){
    log_build_status;
    clear_cache_if_needed

    echo 'Build - old-arch (paper) + static: Begin...'
    yarn run pod-install:old-dynamic
    yarn run build:ios

    if [ $? -eq 0 ]; then
      OLD_ARCH_DYNAMIC=SUCCESS;
    else
      OLD_ARCH_DYNAMIC=FAILED;
    fi
  }

  echo "Starting build for: $BUILD_CURRENT_PATH"
  log_build_status

  build_A1
  build_A2
  build_B1
  build_B2
  build_C2

  echo "\n\n All Builds Completed for: $BUILD_CURRENT_PATH"
  log_build_status

  append_build_status_to_build_log
  echo "Echoing current BUILD_LOG:"
  echo $BUILD_LOG
}

for CURRENT_IOS_DIR_PATH in $EXAMPLE_IOS_DIR_PATHS; do
  echo "CD to: $CURRENT_IOS_DIR_PATH"
  cd "$CURRENT_IOS_DIR_PATH"
  BUILD_CURRENT_PATH=$CURRENT_IOS_DIR_PATH

  run_tests

  # return to lib root
  echo "\n"
  cd "$LIB_ROOT_DIR" || exit
done


prepend_metadata_to_build_log() {
  # collect metadata
  MACOS_VERSION=$(sw_vers)
  XCODE_VERSION=$(xcodebuild -version)
  RUBY_VERSION=$(ruby -v)
  NODE_VERSION=$(node -v)
  NPM_VERSION=$(npm -v)
  YARN_VERSION=$(command -v yarn >/dev/null 2>&1 && yarn -v || echo "Yarn not installed")
  GIT_VERSION=$(git --version)
  TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

  # collect git-specific metadata
  GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  GIT_COMMIT_HASH=$(git rev-parse HEAD)
  GIT_COMMIT_DESC=$(git log -1 --pretty=%B)
  GIT_COMMIT_DATE=$(git log -1 --date=iso --pretty=format:"%cd")

  # build metadata string
  METADATA="Build Environment Metadata:"
  METADATA+="\nTimestamp: $TIMESTAMP"
  METADATA+="\nmacOS Version: $MACOS_VERSION"
  METADATA+="\nXcode Version: $XCODE_VERSION"
  METADATA+="\nRuby Version: $RUBY_VERSION"
  METADATA+="\nNode.js Version: $NODE_VERSION"
  METADATA+="\nnpm Version: $NPM_VERSION"
  METADATA+="\nYarn Version: $YARN_VERSION"
  METADATA+="\nGit Version: $GIT_VERSION"
  METADATA+="\nGit Branch: $GIT_BRANCH"
  METADATA+="\nLast Commit Hash: $GIT_COMMIT_HASH"
  METADATA+="\nLast Commit Description: $GIT_COMMIT_DESC"
  METADATA+="\nLast Commit Date: $GIT_COMMIT_DATE"

  # prepend metadata to BUILD_LOG
  BUILD_LOG="$METADATA\n$BUILD_LOG"
  BUILD_LOG+="\n"
  BUILD_LOG+="\n ------------------------------------------"
  BUILD_LOG+="\n"
}


echo "All builds completed! Echoing BUILD_LOG:"
echo $BUILD_LOG

BUILD_LOG_FILE_NAME="log-test-build-ios-all.txt"
echo "Task - Writing BUILD_LOG to disk: $BUILD_LOG_FILE_NAME"

prepend_metadata_to_build_log
echo "$BUILD_LOG" >> "$BUILD_LOG_FILE_NAME"
