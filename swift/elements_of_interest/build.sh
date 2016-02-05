#!/usr/bin/env bash

PROJ_NAME="elements_of_interest"
PROJ_BUILD_DIR="../../swift_bin"

if [ -n "$PROJ_BUILD_DIR" ]; then
    rm -rf "$PROJ_BUILD_DIR"
fi

xcodebuild -project "$PROJ_NAME".xcodeproj -configuration Release -target "$PROJ_NAME" ARCHS=x86_64 ONLY_ACTIVE_ARCH=YES CONFIGURATION_BUILD_DIR="$PROJ_BUILD_DIR"
