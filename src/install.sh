#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/" && pwd )"

source "${SCRIPT_DIR}/makeSelection.sh"
source "${SCRIPT_DIR}/installShell.sh"
source "${SCRIPT_DIR}/mergeFiles.sh"
source "${SCRIPT_DIR}/version.sh"

registerAliasAndScript() {
    locale application="$1"
    shift
    locale version="$1"
    shift

    printf "\r\n${latest}\r\n"
    if [[ -z ${latest+x} ]]; then
        printf "\r\nPlease select version latest\r\n"
        makeYesNoSelection \
            "latest" \
            "Register ${application}:${version} as latest?"
    elif [[ ${latest} == "No" ]]; then
        makeYesNoSelection \
            "latest" \
            "Register ${application}:${version} as latest?"
    fi
}

runInstall() {
    local ROOT_DIR="$1"
    shift
    local HOME_DIR="$1"
    shift
    local DOCKERIZED_FILE="$1"
    shift

    applications=(`cd ${ROOT_DIR}/applications && ls -d */ | cut -f 1 -d '/'`)

    makeSelectionWithAll \
        "application" \
        "Select application." \
        "${applications[@]}"

    if [[ $application == "All" ]]; then
      for app in "${applications[@]}"
      do
        selectVersion \
            "${ROOT_DIR}" \
            "${HOME_DIR}" \
            "${DOCKERIZED_FILE}" \
            "${app}"
      done
    else
        selectVersion \
            "${ROOT_DIR}" \
            "${HOME_DIR}" \
            "${DOCKERIZED_FILE}" \
            "${application}"

        versions=(`cd ${ROOT_DIR}/applications/${application}/ && ls -d */ | cut -f 1 -d '/'`)
    fi

    installToShell \
        "${HOME_DIR}" \
        "${DOCKERIZED_FILE}"
}
