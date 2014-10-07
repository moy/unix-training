#! /bin/bash

. ./treasure-setup.sh
. ./i18n-lib.sh

# don't delete the directory, it may already have been filled-in by another step.
mkdir -p $(gettext etape)-E3/
cp decoder.adb decoder_bis.adb \
    decoder.c decoder_bis.c \
    $(gettext etape)-E3/
gettext "Jouons maintenant un peu avec les redirections.

Vous trouverez dans cette archive un fichier decoder.adb. Compilez-le
(si vous préférez le C, le programme decoder.c fait la même chose, à
compiler avec gcc).

Ce fichier lit sur son entree une suite de caractères "codee", et
affiche sur sa sortie une version "decodee" de cette suite de
caractères.

Si vous l'executez tel quel, le programme va lire au clavier et
afficher chaque ligne decodee jusqu'a ce que vous terminiez avec
control-d.

Un message code se trouve dans le fichier etape-E4.txt, decodez-le
en utilisant decoder.
" > $(gettext etape)-E3/$(gettext etape)-E3.txt

tar czvf $(gettext etape)-E3.tar.gz \
    $(gettext etape)-E3/*.txt \
    $(gettext etape)-E3/*.adb \
    $(gettext etape)-E3/*.c
