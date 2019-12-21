#!/usr/bin/env bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOME_DIR="$( cd ~ && pwd )"
DOCKERIZED_FILE=${HOME_DIR}/.dockerized

source src/install.sh


runInstall \
    "${ROOT_DIR}" \
    "${HOME_DIR}" \
    "${DOCKERIZED_FILE}"
