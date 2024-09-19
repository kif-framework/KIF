#!/usr/bin/env bash

set -o xtrace
set -o errexit
set -o pipefail

SIMULATOR=$1
RUN_EXTRA_VALIDATIONS=$2

if [ -z "${SIMULATOR}" ]; then
  echo 'Must supply a simulator description in the form of "name=iPad Air,OS=9.2"'
  exit 1
fi

rm -rf ${PWD}/build

# Run KIF Tests
env NSUnbufferedIO=YES xcodebuild test -project KIF.xcodeproj -scheme KIF -derivedDataPath=${PWD}/build/KIF -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

if [ $RUN_EXTRA_VALIDATIONS != "true" ]; then
  exit 0
fi

# Compile the KIF SPM package directly
swift build -Xcc "-isysroot" -Xcc "$(xcrun --sdk iphonesimulator --show-sdk-path)" -Xcc "-target" -Xcc "x86_64-apple-ios$(xcrun --sdk iphonesimulator --show-sdk-version)-simulator"

# Consume KIF via Swift Package Manager in an Xcode project
env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/SPMIntegration/SPMIntegration.xcodeproj" -scheme "SPMIntegration" -derivedDataPath=${PWD}/build/SPMIntegration -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

# Test the "Testable" example project
env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Testable/Testable.xcodeproj" -scheme Testable -derivedDataPath=${PWD}/build/Testable -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

# Test the "TestableSwift" example project
env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/TestableSwift/TestableSwift.xcodeproj" -scheme "TestableSwift" -derivedDataPath=${PWD}/build/TestableSwift -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

# Test the "Calculator" example project
env NSUnbufferedIO=YES xcodebuild test -project "Documentation/Examples/Calculator/Calculator.xcodeproj" -scheme "Calculator" -derivedDataPath=${PWD}/build/Calculator -destination "platform=iOS Simulator,${SIMULATOR}" | xcpretty -c

