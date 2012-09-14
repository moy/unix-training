#! /bin/bash

. ./treasure-setup.sh
. ./i18n-lib.sh
. ./rotlib.sh

gettext "Bravo !

L'etape suivante est accessible depuis votre machine de travail, dans
le repertoire

  \${maindir_tilde}/kmcvoaue/\${step}-E6/

Les instructions sont dans le seul fichier de ce repertoire (et de ses
sous-répertoires) dont le nom se termine par .txt.
" | envsubst | tr "[abcdef1234567890xyzt]" "[1234567890xyztabcdef]" | \
    decalepipe > $(gettext etape)-E3/$(gettext etape)-E5.txt
