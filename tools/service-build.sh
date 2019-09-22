# -------------------------------------------------
# unit test and build a micro-service
# -------------------------------------------------

function buildMicroService() {

    if [ -f "package.json" ]; then
        buildMicroServiceNode
    fi

}

function buildMicroServiceNode() {
    
    # download docker image build
    # download docker image base

    # clear
    rm -rf dist node_modules

    # unit test
    npm install
    npm run test
    rm -rf node_modules

    # build 
    npm install --production
    npm run build

    # create docker image
    # push the docker image

}
