#!/usr/bin/env bash

makeAbstractSelection() {
    local outputVariableName="$1"
    shift
    local question="$1"
    shift
    local disableAll="$1"
    shift
    local options=("$@")

    printf "\r\n${question}\r\n"
    if [[ "${disableAll}" == "0" ]]; then
        allOption=$(( ${#options[@]}+1 ))
        quitOption=$(( ${#options[@]}+2 ))
        updatedOptions=("${options[@]}" "All" "-= Abort =-")
    else
        allOption=$(( ${#options[@]}+2 ))
        quitOption=$(( ${#options[@]}+1 ))
        updatedOptions=("${options[@]}" "-= Abort =-")
    fi

    PS3="Your selection: "

    select opt in "${updatedOptions[@]}"; do
        if [[ $REPLY -ge 1 && $REPLY -lt ${quitOption} ]]; then
            printf "Selected '${opt}'.\r\n"

            eval ${outputVariableName}=${opt}
            break
        elif [[ $REPLY -eq ${quitOption} ]]; then
            printf "\r\nExiting"
            exit 0
        elif [[ "${disableAll}" -eq "0" && $REPLY -eq ${allOption} ]]; then
            printf "Selected '${opt}'.\r\n"

            eval ${outputVariableName}=${opt}
        else
            printf "Invalid option, try again or press [${quitOption}] to quit.\n"
            continue
        fi
    done
}

makeYesNoSelection() {
    local outputVariableName="$1"
    shift
    local question="$1"
    declare -a yesNo
    local yesNo=( "Yes" "No" )

    makeAbstractSelection \
        "${outputVariableName}" \
        "${question}" \
        "1" \
        ${yesNo[@]}
}

makeSelectionWithAll() {
    local outputVariableName="$1"
    shift
    local question="$1"
    shift
    local options=("$@")

    makeAbstractSelection \
        "${outputVariableName}" \
        "${question}" \
        "0" \
        ${options[@]}
}

makeSelection() {
    local outputVariableName="$1"
    shift
    local question="$1"
    shift
    local options=("$@")

    makeAbstractSelection \
        "${outputVariableName}" \
        "${question}" \
        "1" \
        ${options[@]}
}
