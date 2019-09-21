#!/bin/bash

function buildMicroService() {

    cd $PROJECT_ROOT_DIR
    
    if [ -f "package.json" ]; then
        buildMicroServiceNode
    fi

}

function buildMicroServiceNode() {
        # download docker image build
    # download docker image base

    # run unit test before build the application
    # npm install
    # run unit test
    # rm -rf dist node_modules

    # check if package json exist
    npm install --production
    npm run build

    # create docker image
    # push the docker image

}

