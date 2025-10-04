#! /usr/bin/env bash
# ------------------------------------------------------------------
# [Hayden Welch] Refurbisher Interface
#          A CLI interface for running scripts that exist in the 
#           Through-the-Trees/setup-scripts repo.
# ------------------------------------------------------------------

SUBJECT=ttt-distro-setup
VERSION=0.1.0

# TODO: add -b flag for switching branch
USAGE="Usage: setup -hvb distro script"

REPO_URL="https://raw.githubusercontent.com/Through-the-Trees/setup-scripts/refs/heads"
BRANCH="main"
RELEASE=_get_release()

# --- Option processing --------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE
    exit 1;
fi

while getopts ":vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "h")
        _print_help() | echo $USAGE
        exit 0;
        ;;
      "b")
        BRANCH=$OPTARG
        echo "Using branch $BRANCH"
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG"
        exit 0;
        ;;
      ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
      *)
        echo "Unknown error while processing options"
        exit 0;
        ;;
    esac
  done

shift $(($OPTIND - 1))

distro=$1
script=$2
# -----------------------------------------------------------------

LOCK_FILE=/tmp/${SUBJECT}.lock

if [ -f "$LOCK_FILE" ]; then
echo "Script is already running"
exit
fi

# -----------------------------------------------------------------
trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE 

# -----------------------------------------------------------------
#  SCRIPT LOGIC GOES HERE
# -----------------------------------------------------------------

# TODO: Buid a help/usage message 
_print_help() {
  echo "ttt-setup"
  echo "Release: " _get_release()
  echo "Script Options: "
  while read -r _get_scripts()
}

_get_release() {
  # TODO: Get release info from /etc/os-release
}

_list_options() {
  # TODO: Get options for release
}

# Takes one arg (last part of script path)
# E.G. linux/zorin/setup.sh
_run_script() {
  curl $REPO_URL/$BRANCH/$1 | bash || echo "Failed to run $1 exiting..."
}