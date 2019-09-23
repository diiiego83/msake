# -----------------------------------------------
# check requirements
# -----------------------------------------------

# check if program exist or exit
function checkProgram() {
    if ! [ -x "$(command -v $1)" ]; then
        printf "\n[msake-error] program \"$1\" not installed\n"
        exit 1
    fi
}

function checkRequirements() {

    # check if git is installed
    checkProgram git

    # check user.name is set in git
    GIT_USERNAME="$(git config --get user.name)"
    if [ -z "$GIT_USERNAME" ]; then
        printf "\n[msake-error] git config user.name is not set\n"
        exit 1
    fi

    # check if user.email is set in git
    GIT_EMAIL="$(git config --get user.email)"
    if [ -z "$GIT_EMAIL" ]; then
        printf "\n[msake-error] git config user.email is not set\n"
        exit 1
    fi

}
