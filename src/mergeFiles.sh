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
    local aliasFile="${ROOT_DIR}/applications/${application}/${version}/alias"
    local aliasCustomFile="${aliasFile}Custom"
    local latestAlias="alias ${application}="
    local updateAlias="alias dockerized-update-${application}="

    if [[ -f "$DOCKERIZED_FILE" ]]; then
        mv ${DOCKERIZED_FILE} ${dockerizedOld}
    else
        touch ${dockerizedOld}
    fi

    printf "\r\nMerging aliases...\r\n"

    while read line; do
        if [[ $latest == "Yes" && $line == $latestAlias* ]]; then
            echo ${line//alias ${application}=/alias ${application}=}
            echo ${line//alias ${application}=/alias ${application}${version}=}
        elif [[ $latest == "Yes" && $line == $updateAlias* ]]; then
            echo ${line//alias dockerized-update-${application}=/alias dockerized-update-${application}${version}=}
            echo ${line//alias dockerized-update-${application}=/alias dockerized-update-${application}=}
        elif [[ $latest == "No" && $line == $latestAlias* ]]; then
            echo ${line//alias ${application}=/alias ${application}${version}=}
        elif [[ $latest == "No" && $line == $updateAlias* ]]; then
            echo ${line//alias dockerized-update-${application}=/alias dockerized-update-${application}${version}=}
        elif [[ $latest == "Yes" ]]; then
            echo ${line}
             echo ${line} | sed -E "s/alias (.*)='(.*)/alias \1${version}='\2/"
        else
             echo ${line} | sed -E "s/alias (.*)='(.*)/alias \1${version}='\2/"
        fi
    done < ${aliasFile} > ${aliasCustomFile}${version}

    while read line; do
        if [[ $latest == "Yes" && $line ==  $latestAlias* ]]; then
            line=""
        elif [[ $latest == "Yes" && $line == $updateAlias* ]]; then
            line=""
        else
            echo "$line"
        fi
    done < ${dockerizedOld} > ${dockerizedOld}${version}

    echo "---------\Merging files/---------------"
    sort ${dockerizedOld}${version} ${aliasCustomFile}${version} | uniq >> ${DOCKERIZED_FILE}
    echo "---------\Removing tmp files/---------------"
    rm ${dockerizedOld}
    rm ${dockerizedOld}${version}
    rm ${aliasCustomFile}${version}

}

#alias composer='docker run --rm --interactive --tty --volume $PWD:/app -w /app --user $(id -u):$(id -g) composer:1 composer'
#alias dockerized-update-composer='docker pull composer:1'
