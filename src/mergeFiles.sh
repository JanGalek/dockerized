#!/usr/bin/env bash

mergeFiles() {
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
    shift
    local dockerizedOld=${HOME_DIR}/.dockerized.old

    if [[ -f "$DOCKERIZED_FILE" ]]; then
        mv ${DOCKERIZED_FILE} ${dockerizedOld}
    else
        touch ${dockerizedOld}
    fi

    printf "\r\nMerging aliases...\r\n"

#    if [[ $latest == "Yes" ]]; then
#        sort ${dockerizedOld} ${ROOT_DIR}/applications/${application}/${version}/alias | uniq | sed "s/" >> ${DOCKERIZED_FILE}
#    else
#        sort ${dockerizedOld} ${ROOT_DIR}/applications/${application}/${version}/alias | uniq >> ${DOCKERIZED_FILE}
#    fi
    sort ${dockerizedOld} ${ROOT_DIR}/applications/${application}/${version}/alias | uniq >> ${DOCKERIZED_FILE}
    rm ${dockerizedOld}
}

#alias composer='docker run --rm --interactive --tty --volume $PWD:/app -w /app --user $(id -u):$(id -g) composer:1 composer'
#alias dockerized-update-composer='docker pull composer:1'
