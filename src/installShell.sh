#!/usr/bin/env bash

installToShell_AddSource() {
    local HOME_DIR="$1"
    shift
    local shellConfig="$1"
    shift
    local sourceString="source ${HOME_DIR}/.dockerized"
    local configPath="${HOME_DIR}/${shellConfig}"

    if grep -q "${sourceString}" "${configPath}"; then
      printf "\r\nConfig already added to ${shellConfig}"
    else
      printf "\r\nAdding config to ${shellConfig}"
      printf "${sourceString}" >>${configPath}
    fi
}

installToShell() {
    local HOME_DIR="$1"
    shift
    local DOCKERIZED_FILE="$1"
    shift

    bashConfigs=(`cd ${HOME_DIR}/ && ls -p -a | grep -v / | grep -v "${DOCKERIZED_FILE}" | grep -v '.vimrc' | grep "^.*rc$" | cut -f 1 -d '/'`)

    makeSelectionWithAll \
      "shellConfig" \
      "Select shell config" \
      "${bashConfigs[@]}"

    if [[ $shellConfig == "All" ]]; then
      for config in "${bashConfigs[@]}"
      do
        echo ${config}
        installToShell_AddSource \
            "${HOME_DIR}" \
            "${config}"
      done
    else
      installToShell_AddSource \
            "${HOME_DIR}" \
            "${shellConfig}"
    fi
}
