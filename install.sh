#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$( cd ~ && pwd )"

makeSelection() {
    local outputVariableName="$1"
    shift
    local question="$1"
    shift
    local options=("$@")
    local quitOption=$(( ${#options[@]}+2 ))
    local allOption=$(( ${#options[@]}+1 ))

    echo "${question}"
    PS3="Your selection: "

    select opt in "${options[@]}" "All" "-= Abort =-"; do
        if [[ $REPLY -ge 1 && $REPLY -lt ${quitOption} ]]; then
            echo "Selected '${opt}'."

            eval ${outputVariableName}=${opt}
            break
        elif [[ $REPLY -eq ${quitOption} ]]; then
            exit 0
        elif [[ $REPLY -eq ${allOption} ]]; then
            echo "Selected '${opt}'."

            eval ${outputVariableName}=${opt}
        else
            echo "Invalid option, try again or press [${quitOption}] to quit.\n"
            continue
        fi
    done
}

installApplication() {
    local application="$1"
    shift
    local version="$1"
    local dockerized=${HOME_DIR}/.dockerized
    local dockerizedOld=${HOME_DIR}/.dockerized.old

    bashConfigs=(`cd ${HOME_DIR}/ && ls -p -a | grep -v / | grep -v "$dockerized" | grep -v '.vimrc' | grep "^.*rc$" | cut -f 1 -d '/'`)

    makeSelection \
      "shellConfig" \
      "Select shell config" \
      "${bashConfigs[@]}"

    if [ -f "$dockerized" ]; then
        mv ${dockerized} ${dockerizedOld}
    else
        touch ${dockerizedOld}
    fi

    lineContain \
        "${dockerized}.new" \
        "${dockerizedOld}" \
        "${SCRIPT_DIR}/applications/${application}/${version}/alias"

    #cat ${SCRIPT_DIR}/applications/${application}/${version}/alias >> ${dockerized}.new

    mv ${dockerized}.new ${dockerized}
}

lineContain() {
    local dockerizedNew="$1"
    shift
    local dockerizedOld="$1"
    shift
    local aliasFile="$1"
    shift

    echo "---READ---"
    while read aliasLine; do
        while read oldLine; do
            echo ${p}

              if cat ${file} | grep -xqFe "${p}"; then
                echo ""
              else
                echo ${p} >> "${dockerizedNew}"
              fi
        done <${aliasFile}
    done <${aliasFile}
    echo "---\READ/---"
}


existingContainerName=(`cd ${SCRIPT_DIR}/applications && ls -d */ | cut -f 1 -d '/'`)

makeSelection \
    "application" \
    "Select application." \
    "${existingContainerName[@]}"


if [[ $application = "All" ]]; then
  echo "All"
else
  existingContainerVersion=(`cd ${SCRIPT_DIR}/applications/${application}/ && ls -d */ | cut -f 1 -d '/'`)

  makeSelection \
      "version" \
      "Select version." \
      "${existingContainerVersion[@]}"

  installApplication \
    "${application}" \
    "${version}"
fi

