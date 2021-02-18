#!/usr/bin/env bash

set -o xtrace
set -o errexit
set -o pipefail

SIMULATOR=$1

function xcode_major() {
  if [ -z $XCODE_MAJOR ]; then
    XCODE_MAJOR=`xcodebuild -version | head -n1 | sed -e "s/Xcode //" | cut -d '.' -f1`
  fi
  echo "$XCODE_MAJOR"
}

function is_xcode_version_above() {
  if [[ `xcode_major` -ge $1 ]]; then
    return 0
  else
    return 1
  fi
}

if [ -z "${SIMULATOR}" ]; then
  echo 'Must supply a simulator description in the form of "name=iPad Air,OS=9.2"'
  exit 1
fi

rm -rf ${PWD}/build

env NSUnbufferedIO=YES xcodebuild test -project KIF.xcodeproj -derivedDataPath=${PWD}/build/KIFFramework -scheme KIFFrameworkConsumerTests -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
env NSUnbufferedIO=YES xcodebuild test -project KIF.xcodeproj -scheme KIF -derivedDataPath=${PWD}/build/KIF -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

# Due to unstable Swift language syntax, this only compiles on Xcode 8+
if is_xcode_version_above 11; then
  env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Testable Swift/Testable Swift.xcodeproj" -scheme "Testable Swift" -derivedDataPath=${PWD}/build/TestableSwift -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
fi

env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Testable/Testable.xcodeproj" -scheme Testable -derivedDataPath=${PWD}/build/Testable -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
# For some reason, attempting to run the Calculator tests on Xcode 7 causes a frequent crash in CI
env NSUnbufferedIO=YES xcodebuild build -project "Documentation/Examples/Calculator/Calculator.xcodeproj" -scheme "Calculator" -derivedDataPath=${PWD}/build/Calculator -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

if ! is_xcode_version_above 12 ; then # see https://github.com/Carthage/Carthage/issues/3019 for Xcode 12 support
  carthage build --no-skip-current
  carthage archive KIF
fi

swift build -Xcc "-isysroot" -Xcc "$(xcrun --sdk iphonesimulator --show-sdk-path)" -Xcc "-target" -Xcc "x86_64-apple-ios$(xcrun --sdk iphonesimulator --show-sdk-version)-simulator"
