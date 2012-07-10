#! /bin/bash

. ./treasure-setup.sh
. ./i18n-lib.sh
. ./rotlib.sh

gettext "Bravo !

L'etape suivante se trouve sur telesun, dans le repertoire
\$maindir/kmcvoaue/\${step}-E6/

Les instructions sont dans le seul fichier de ce repertoire (et de ses
sous-répertoires) dont le nom se termine par .txt.
" | envsubst | tr "[abcdef1234567890xyzt]" "[1234567890xyztabcdef]" | \
    decalepipe > $(gettext etape)-E3/$(gettext etape)-E5.txt
