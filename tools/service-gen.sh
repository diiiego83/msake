function parseInputArgs() {

    for i in "$@"; do
        case $i in
            --language=*)
            LANGUAGE="${i#*=}"
            shift
            ;;
            --service-name=*)
            SVCNAME="${i#*=}"
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

    if [ -z $SVCNAME ]; then
        printf "\n[msake-error] required input arguments --service-name=<name of the service>\n"
        exit 1
    fi

    # lowercase
    LANGUAGE="$(echo "$LANGUAGE" | tr '[:upper:]' '[:lower:]')"
    SVCNAME="$(echo "$SVCNAME" | tr '[:upper:]' '[:lower:]')"

}

function createMicroService() {

    parseInputArgs $@

    # [todo] do no create if exist
    mkdir $SVCNAME
    cd $SVCNAME

    if [ "$LANGUAGE" == "node" ]; then

        cp -r $MSAKE_ROOT_DIR/models/node/* .
        cp $MSAKE_ROOT_DIR/models/node/.gitignore .
        mv package package.json
        mv README README.md
        mv tsconfig tsconfig.json
        mv tslint tslint.json
        mv src/main src/main.ts
        mv src/server/index src/server/index.ts
        mv src/server/server src/server/server.ts

    elif [ "$LANGUAGE" == "go" ]; then
        cp -r $MSAKE_ROOT_DIR/models/go/* .
        cp $MSAKE_ROOT_DIR/models/go/.gitignore .
    elif [ "$LANGUAGE" == "python" ]; then
        cp -r $MSAKE_ROOT_DIR/models/python/* .
        cp $MSAKE_ROOT_DIR/models/python/.gitignore .
    else
        printf "\n[msake-error] the \"$LANGUAGE\" is not a supported language, --language=<node python go>\n"
        exit 1    
    fi

    # replace token service-name
    find . -type f -exec sed -i "s/#{service-name}#/$SVCNAME/g" {} +
    
    # set title in README.md
    echo "# $(tr '[:lower:]' '[:upper:]' <<< ${SVCNAME:0:1})${SVCNAME:1}"> README.md

}