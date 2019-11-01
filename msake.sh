#!/bin/bash
# -----------------------------------------------
# msake - main execution script
# -----------------------------------------------

# print help menu and exit 
function help() {
    printf "$0  create, build, help\n\n"
    printf "%s\n" "  create - create a new micro-service"
    printf "%s\n" "  build  - build a micro-service"
    printf "%s\n" "  help   - display this help menu"
    exit $1
}

# msake main
function main() {

    # set the msake dir
    MSAKE_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

    # check requirements
    source $MSAKE_DIR/tools/requirements.sh
    checkRequirements

    # from here exit when any command fails
    set -e

    # argument required
    if [ -z "$1" ]; then
        printf "\n[msake-error] missing argument\n\n"; 
        help 1
    fi

    # set the running mode (first input argument)
    RUN_MODE=$1; shift;
    RUN_MODE="$(echo "$RUN_MODE" | tr '[:upper:]' '[:lower:]')"

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

}

# run msake
main $@