#!/usr/bin/env bash

selectVersion() {
    local ROOT_DIR="$1"
    shift
    local HOME_DIR="$1"
    shift
    local DOCKERIZED_FILE="$1"
    shift
    local application="$1"
    shift
    local versions=(`cd ${ROOT_DIR}/applications/${application}/ && ls -d */ | cut -f 1 -d '/'`)

    makeSelectionWithAll \
      "version" \
      "Select ${application} version." \
      "${versions[@]}"

    makeYesNoSelection \
        "versionAlias" \
        "Register automatically application with versions suffix?"

    if [[ $version == "All" ]]; then
        makeSelection \
          "latest" \
          "Which version of ${application} register as ${application}?" \
          "${versions[@]}"

      for version2 in "${versions[@]}"
      do
        if [[ $versionAlias == "No" ]]; then
            makeYesNoSelection \
                "alias" \
                "Register ${application}:${version2} as ${application}${version2}?"
        fi

        if [[ $latest == $version2 ]]; then
            locale isLatest="Yes"
        else
            locale isLatest="No"
        fi

        installApplication \
            "${ROOT_DIR}" \
            "${HOME_DIR}" \
            "${DOCKERIZED_FILE}" \
            "${application}" \
            "${version2}" \
            "${latest}"
      done
    else
        makeYesNoSelection \
            "latest" \
            "Register as latest?"

        installApplication \
            "${ROOT_DIR}" \
            "${HOME_DIR}" \
            "${DOCKERIZED_FILE}" \
            "${application}" \
            "${version}" \
            "${latest}"
    fi
}

installApplication() {
    local ROOT_DIR="$1"
    shift
    local HOME_DIR="$1"
    shift
    local DOCKERIZED_FILE="$1"
    shift
    local application="$1"
    shift
    local version="$1"
    shift
    local latest="$1"

    printf "\r\nInstalling ${application}:${version}"
    mergeFiles \
        "${ROOT_DIR}" \
        "${HOME_DIR}" \
        "${DOCKERIZED_FILE}" \
        "${application}" \
        "${version}" \
        "${latest}"
}
