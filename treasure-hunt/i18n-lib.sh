#! /bin/sh

export TEXTDOMAINDIR=$(pwd)
export TEXTDOMAIN=hunt

. gettext.sh

if [ "$DEBUG" != "" ]; then
    gettext "Generating step using locale:"
    echo
    locale
fi

lang_do() {
    lang=$1
    shift
    (
	LANG="$lang"
	LC_ALL="$lang"
	export LANG LC_ALL
	"$@"
    )
}

multilingual_do () {
    lang_do fr_FR.UTF-8 "$@"
    lang_do en_US.UTF-8 "$@"
}

step=$(gettext etape)
export step

