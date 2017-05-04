#!/usr/bin/env bash

set -o xtrace
set -o errexit
set -o pipefail

SIMULATOR=$1

if [ -z "${SIMULATOR}" ]; then
  echo 'Must supply a simulator description in the form of "name=iPad Air,OS=9.2"'
  exit 1
fi

# Workaround https://github.com/travis-ci/travis-ci/issues/3040
open -b com.apple.iphonesimulator

rm -rf ${PWD}/build

XCODE_VERSION=`xcodebuild -version | head -n1 | sed -e "s/Xcode //"`

env NSUnbufferedIO=YES xcodebuild test -project KIF.xcodeproj -derivedDataPath=${PWD}/build/KIFFramework -scheme KIFFrameworkConsumerTests -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
env NSUnbufferedIO=YES xcodebuild test -project KIF.xcodeproj -scheme KIF -derivedDataPath=${PWD}/build/KIF -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

# Due to unstable Swift language syntax, this only compiles on Xcode 8+
if [[ $XCODE_VERSION =~ (8|9|1[0-9]+)\.[0-9.]+ ]]; then
  env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Testable Swift/Testable Swift.xcodeproj" -scheme "Testable Swift" -derivedDataPath=${PWD}/build/TestableSwift -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
fi

env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Testable/Testable.xcodeproj" -scheme Testable -derivedDataPath=${PWD}/build/Testable -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Calculator/Calculator.xcodeproj" -scheme "Calculator" -derivedDataPath=${PWD}/build/Calculator -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c
