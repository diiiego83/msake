function parseInputArgs() {

    for i in "$@"; do
        case $i in
            --language=*)
            LANGUAGE="${i#*=}"
            shift
            ;;
            --service-name=*)
            SERVICE_NAME="${i#*=}"
            shift
            ;;            
            *) 
            printf "\n[msake-error] \"$1\" is not a valid argument\n"
            exit 1
            ;;
        esac
    done

    if [ -z $LANGUAGE ]; then
        printf "\n[msake-error] required input arguments --language=<node python go>\n"
        exit 1
    fi

    if [ -z $SERVICE_NAME ]; then
        printf "\n[msake-error] required input arguments --service-name=<name of the service>\n"
        exit 1
    fi

    # lowercase
    LANGUAGE="$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')"
    SERVICE_NAME="$(echo "$SERVICE_NAME" | tr '[:upper:]' '[:lower:]')"

}

function createMicroService() {

    parseInputArgs $@

    if [ -d "$SERVICE_NAME" ]; then
        printf "\n[msake-error] $SERVICE_NAME already exist in folder\n"
        exit 1
    fi
    mkdir $SERVICE_NAME
    cd $SERVICE_NAME
    SERVICE_DIR=$(pwd)

    if [ "$LANGUAGE" == "node" ]; then

        cp -r $MSAKE_DIR/models/node/* .
        cp $MSAKE_DIR/models/node/.gitignore .
        mv package package.json
        mv README README.md
        mv tsconfig tsconfig.json
        mv tslint tslint.json
        mv src/main src/main.ts
        mv src/server/index src/server/index.ts
        mv src/server/server src/server/server.ts

    elif [ "$LANGUAGE" == "go" ]; then
        cp -r $MSAKE_DIR/models/go/* .
        cp $MSAKE_DIR/models/go/.gitignore .
    elif [ "$LANGUAGE" == "python" ]; then
        cp -r $MSAKE_DIR/models/python/* .
        cp $MSAKE_DIR/models/python/.gitignore .
    else
        printf "\n[msake-error] the \"$LANGUAGE\" is not a supported language, --language=<node python go>\n"
        exit 1    
    fi

    # replace token service-name
    find . -type f -exec sed -i "s/#{service-name}#/$SERVICE_NAME/g" {} +
    
    # set title in README.md
    echo "# $(tr '[:lower:]' '[:upper:]' <<< ${SERVICE_NAME:0:1})${SERVICE_NAME:1}"> README.md

    # init git and submodule
    git init
    cd $MSAKE_DIR
    MSAKE_GIT_URL_REMOTE="$(git config --get remote.origin.url)"
    cd $SERVICE_DIR
    git submodule add $MSAKE_GIT_URL_REMOTE

    # create the first commit
    git add .
    git commit -m "msake initialization"

}