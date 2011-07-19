#! /bin/bash

rm -fr php
mkdir -p php

. ./spy-lib.sh

all_questions () {
    :
}

EXAM_DIR=../../gen-exam/
. "$EXAM_DIR"/exam-lib.sh

outdir=.
exam_install_php
exam_config_php sql > php/inc/config.php

rm -fr php/*.png php/*.php php/private/

(cd src && git ls-files | tar cf - -T -) | \
    (mkdir -p php/spy; cd php/spy && tar xf -)
