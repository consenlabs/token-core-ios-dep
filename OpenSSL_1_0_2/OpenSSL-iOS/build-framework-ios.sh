#!/bin/sh

#  build-framework-ios.sh
#  OpenSSL-iOS
#
#  Created by Josip Cavar on 15/07/16.
#  Modifications by @levigroker
#  Copyright © 2016 krzyzanowskim. All rights reserved.


set -e
set +u
# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1


# Constants
SF_TARGET_NAME=${PRODUCT_NAME}
UNIVERSAL_OUTPUTFOLDER=${SRCROOT}/bin

# Take build target
if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
SF_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SF_SDK_PLATFORM" != "iphoneos" ]]
then
echo "Please choose iPhone device as the build target instead of $SF_SDK_PLATFORM."
exit 1
fi

IPHONE_DEVICE_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos

function build() {
    xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk $1 BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/$2" SYMROOT="${SYMROOT}" ARCHS="$3" VALID_ARCHS="$3" $ACTION
}

# Build the other (non-simulator) platform
build 'iphoneos' 'arm64' 'arm64'
build 'iphoneos' 'armv7' 'armv7 armv7s'

# Build simulator platform
build 'iphonesimulator' 'i386' 'i386'

# Copy the framework structure to the universal folder (clean it first)
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
cp -R "${IPHONE_DEVICE_BUILD_DIR}/${SF_TARGET_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework"

# Smash them together to combine all architectures
lipo -create  "${BUILD_DIR}/${CONFIGURATION}-iphoneos/arm64/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/armv7/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${SF_TARGET_NAME}.framework/${SF_TARGET_NAME}"
