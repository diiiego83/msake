#!/bin/bash

MSAKE_ROOT_DIR="$( cd "$(dirname "$0")" ; pwd -P )"

CMD=$1; shift;
CMD="$(echo "$CMD" | tr '[:upper:]' '[:lower:]')"

if [ "$CMD" == "create" ]; then
    source $MSAKE_ROOT_DIR/tools/service-gen.sh
    createMicroService $@
    exit 0
fi

if [ "$CMD" == "build" ]; then
    source $MSAKE_ROOT_DIR/tools/service-build.sh
    buildMicroService $@
    exit 0
fi

if [ ! -z "$CMD" ]; then
    printf "\n[msake-error] The command \"$CMD\" is not supported\n"
else
    printf "\n[msake-error] The command has not been specified\n"    
fi
exit 1