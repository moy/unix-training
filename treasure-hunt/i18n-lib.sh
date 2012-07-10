#! /bin/sh

export TEXTDOMAINDIR=$(pwd)
export TEXTDOMAIN=hunt

. gettext.sh

if [ "$DEBUG" != "" ]; then
    gettext "Generating step using locale:"
    echo
    locale
fi

multilingual_do () {
    LANG=fr_FR.UTF-8 "$@"
    LANG=en_US.UTF-8 "$@"
}

step=$(gettext etape)
export step
