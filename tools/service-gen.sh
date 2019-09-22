# -------------------------------------------------
# create a microservice in node, go or python
# -------------------------------------------------

function help() {
    printf "$0  create --language=* --service-name=*\n\n"
    printf "%s\n" "--language      - service lsanguage node, go or python"
    printf "%s\n" "--service-name  - name of the service "
    printf "%s\n" "--help          - display this help menu"
    exit $1
}

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
            --help)
            HELP=YES
            shift
            ;;          
            *)             
            printf "\n[msake-error] \"$1\" is not a valid argument\n\n"
            help 1
            ;;
        esac
    done
    
    if [ ! -z $HELP ]; then
        printf "\n"; help 0
    fi

    if [ -z $LANGUAGE ]; then
        printf "\n[msake-error] argument --language missing\n\n"
        help 1
    fi

    if [ -z $SERVICE_NAME ]; then
        printf "\n[msake-error] argument --service-name missing\n\n"
        help 1
    fi

    # lowercase
    LANGUAGE="$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')"
    SERVICE_NAME="$(echo "$SERVICE_NAME" | tr '[:upper:]' '[:lower:]')"

}

function createMicroService() {

    parseInputArgs $@

    if [ -d "$SERVICE_NAME" ]; then
        printf "\n[msake-error] $SERVICE_NAME already exist in folder.\n\n"
        help 1
    fi

    P="== "
    printf "${P}msake create serice ${SERVICE_NAME}\n" 
    printf "${P}create source directory\n"
    mkdir $SERVICE_NAME
    cd $SERVICE_NAME
    SERVICE_DIR=$(pwd)

    if [ "$LANGUAGE" == "node" ]; then

        printf "${P}copy source model\n"
        cp -r $MSAKE_DIR/models/node/* .
        cp $MSAKE_DIR/models/node/.gitignore .
        mv package package.json
        mv README README.md
        mv tsconfig tsconfig.json
        mv tslint tslint.json
        mv src/main src/main.ts
        mv src/server/index src/server/index.ts
        mv src/server/server src/server/server.ts
        mv tests/test tests/test.ts

    elif [ "$LANGUAGE" == "go" ]; then
        cp -r $MSAKE_DIR/models/go/* .
        cp $MSAKE_DIR/models/go/.gitignore .
    elif [ "$LANGUAGE" == "python" ]; then
        cp -r $MSAKE_DIR/models/python/* .
        cp $MSAKE_DIR/models/python/.gitignore .
    else
        rm -rf $SERVICE_DIR
        printf "\n[msake-error] \"$LANGUAGE\" is not supported.\n\n"
        help 1
    fi

    # replace token service-name
    find . -type f -exec sed -i "s/#{service-name}#/$SERVICE_NAME/g" {} +
    
    # set title in README.md
    echo "# $(tr '[:lower:]' '[:upper:]' <<< ${SERVICE_NAME:0:1})${SERVICE_NAME:1}"> README.md

    # init git and submodule
    printf "${P}create git repository\n"    
    git init
    cd $MSAKE_DIR
    MSAKE_GIT_URL_REMOTE="$(git config --get remote.origin.url)"
    cd $SERVICE_DIR
    git submodule add $MSAKE_GIT_URL_REMOTE

    # install packages
    printf "${P}install default third party dependecies\n"
    npm install

    # create the first commit
    printf "${P}perform first commit\n"
    git add .
    git commit -m "msake initialization"

    printf "${P}service ${SERVICE_NAME} succesfully created\n";

}