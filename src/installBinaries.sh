#!/usr/bin/env bash

installBinaries() {
    local ROOT_DIR="$1"
    shift
    local HOME_DIR="$1"
    shift
    local application="$1"
    shift
    local version="$1"
    shift
    local latest="$1"

    binaryPath="$HOME_DIR/bin/dockerized"
    appPath="$ROOT_DIR/applications/$application/$version"

    if [ ! -d "$binaryPath" ]; then
      mkdir -p "$binaryPath"
    fi

    printf "\r\nCopying scripts to $binaryPath\r\n"

    for filePath in $appPath/*; do
      filename="$(basename "$filePath")"
      if [[ "$filename" != "alias" ]]; then
        cp "$filePath" "$binaryPath/$filename$version"
        chmod +x "$binaryPath/$filename$version"
        if [ "$latest" == "Yes" ]; then
          cp "$filePath" "$binaryPath/$filename"
          chmod +x "$binaryPath/$filename"
        fi
      fi
    done
}
