#! /bin/sh

. ./treasure-setup.sh
. ./spy-lib.sh
. ./i18n-lib.sh

gettext 'Bien joué !

Les fichiers cachés sont simplement ceux dont le nom commence par un
point, on peut les manipuler comme les autres, mais "ls" ne les
affiche pas. Par contre, "ls -a" les affiche.

Les étapes suivantes se trouvent dans une archive TAR compressée,
disponible ici :

$web_url/etape-E3.tar.gz
' | envsubst > dot-$(gettext etape)-E2.txt
