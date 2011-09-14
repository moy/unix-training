#! /bin/bash

. ./i18n-lib.sh
. ./adalib.sh
. ./odtlib.sh

HUNT_DIR=$(pwd)

exec > $(gettext etape)_d2.adb

gettext "Fichier source pour l'etape D2.
Le programme est coupé en 3 morceaux.
Assemblez-les puis compilez le programme.
" | ada_comment_out

adawithuse

gettext "procedure Etape_D2 is"
echo
adadecode
echo "begin"

gettext "Visiblement, le copier-coller a marché !

L'etape suivante se trouve dans le fichier

~moy/jeu-de-piste/oaue/etape-E1

La personne qui a créé ce fichier l'a nommé étrangement :
il n'a pas mis d'extension (i.e. le nom de fichier ne se 
termine pas par .quelquechose). Pour savoir de quel type
de fichier il s'agit, utilisez la commande 'file', et
utilisez ensuite l'outil adapté pour l'ouvrir.
" | ada_obfuscate

gettext "end Etape_D2;"
echo

gettext "etape_d2.adb genere" >&2
echo >&2

sed -ne '1,8p' $(gettext etape)_d2.adb | txt2odt $(gettext etape)_d2-1.odt

sed -ne '9,16p' $(gettext etape)_d2.adb > $(gettext etape)_d2-2.txt

sed -ne '17,$p' $(gettext etape)_d2.adb > $(gettext etape)_d2-3.txt
