#! /bin/bash


usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--web-passwd	Password for web interface
EOF
}

exam_suffix=

while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
        "--web-passwd")
	    shift
	    exam_webpass="$1"
            ;;
        *)
            echo "unrecognized option $1"
            usage
            exit 1
            ;;
    esac
    shift
done

rm -fr php
mkdir -p php

. ./spy-lib.sh

all_questions () {
    : nothing needed here
}

EXAM_DIR=../../gen-exam/
. "$EXAM_DIR"/exam-lib.sh

outdir=.
exam_install_php
exam_config_php sql > php/inc/config.php
perl -pi -e 's/\$exam_webuser/\$exam_suffix = '"'$exam_suffix'"';\n\$exam_webuser/' php/inc/config.php

rm -fr php/*.png php/*.php php/private/

(cd src && git ls-files | tar cf - -T -) | \
    (cd php/ && tar xf -)
