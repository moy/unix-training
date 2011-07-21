#! /bin/sh

export TEXTDOMAINDIR=$(pwd)
export TEXTDOMAIN=hunt

. gettext.sh

if [ "$DEBUG" != "" ]; then
    gettext "Generating step using locale:"
    echo
    locale
fi
