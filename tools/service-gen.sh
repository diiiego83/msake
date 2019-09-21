function parseInputArgs() {

    for i in "$@"; do
        case $i in
            --language=*)
            LANGUAGE="${i#*=}"
            shift
            ;;
            *) 
            printf "\n[msake-error] \"$1\" is not a valid argument\n"
            exit 1
            ;;
        esac
    done

    if [ -z $LANGUAGE ]; then
        printf "\n[msake-error] required input arguments --language=node|python|go\n"
        exit 1
    fi

}

function createMicroService() {

    parseInputArgs $@

    if [ "$LANGUAGE" == "node" ]; then
        cp -r $MSAKE_ROOT_DIR/lib/templates/code/node/* $PROJECT_ROOT_DIR
<<<<<<< HEAD
    elif [ "$LANGUAGE" == "go" ]; then
        cp -r $MSAKE_ROOT_DIR/lib/templates/code/go/* $PROJECT_ROOT_DIR
    elif [ "$LANGUAGE" == "python" ]; then
        cp -r $MSAKE_ROOT_DIR/lib/templates/code/python/* $PROJECT_ROOT_DIR
=======
        cp $MSAKE_ROOT_DIR/lib/templates/code/node/.gitignore $PROJECT_ROOT_DIR
    elif [ "$LANGUAGE" == "go" ]; then
        cp -r $MSAKE_ROOT_DIR/lib/templates/code/go/* $PROJECT_ROOT_DIR
        cp $MSAKE_ROOT_DIR/lib/templates/code/go/.gitignore $PROJECT_ROOT_DIR
    elif [ "$LANGUAGE" == "python" ]; then
        cp -r $MSAKE_ROOT_DIR/lib/templates/code/python/* $PROJECT_ROOT_DIR
        cp $MSAKE_ROOT_DIR/lib/templates/code/python/.gitignore $PROJECT_ROOT_DIR
>>>>>>> added build tools and update template node
    else
        printf "\n[msake-error] the \"$LANGUAGE\" is not a valid language value, supported --language=node|python|go\n"
        exit 1    
    fi

}