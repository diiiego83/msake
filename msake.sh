#!/bin/bash
# -----------------------------------------------
# msake - main execution script
# -----------------------------------------------

# exit when any command fails
set -e

function help() {
    printf "$0  create, build, help\n\n"
    printf "%s\n" "- create - create a new micro-service"
    printf "%s\n" "- build  - build a micro-service"
    printf "%s\n" "- help   - display this help menu"
    exit $1
}

# argument required
if [ -z "$1" ]; then
    printf "\n[msake-error] missing argument\n\n"; 
    help 1
fi

# set the running mode (first input argument)
RUN_MODE=$1; shift;
RUN_MODE="$(echo "$RUN_MODE" | tr '[:upper:]' '[:lower:]')"

# set the msake dir
MSAKE_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

# create a new micro service
if [ "$RUN_MODE" == "create" ]; then
    source $MSAKE_DIR/tools/service-gen.sh
    createMicroService $@
    exit 0
fi

# build a micro-service
if [ "$RUN_MODE" == "build" ]; then
    source $MSAKE_DIR/tools/service-build.sh
    buildMicroService $@
    exit 0
fi

# display help menu
if [ "$RUN_MODE" == "help" ]; then
    printf "\n[ msake - micro-services make ]\n\n";
    help
fi

# input arguments error handling
printf "\n[msake-error] \"$RUN_MODE\" is not supported\n\n"
help 1