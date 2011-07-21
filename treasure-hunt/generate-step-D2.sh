#! /bin/bash

. ./i18n-lib.sh
. ./adalib.sh

exec > $(gettext etape)_d2.adb

gettext -- "-- Fichier source pour l'etape D2.
-- Le programme est coupé en 3 morceaux.
-- Assemblez-les puis compilez le programme.

"
adawithuse

gettext "procedure Etape_D2 is"
echo
adadecode
echo "begin"

Put_Line "$(gettext "Visiblement, le copier-coller a marché !")"
New_Line
Put_Line "$(gettext "L'etape suivante se trouve dans le fichier")"
New_Line 
Put_Line "$(gettext "~moy/jeu-de-piste/oaue/etape-E1")"
New_Line
Put_Line "$(gettext "La personne qui a créé ce fichier l'a nommé étrangement :")"
Put_Line "$(gettext "il n'a pas mis d'extension (i.e. le nom de fichier ne se ")"
Put_Line "$(gettext "termine pas par .quelquechose). Pour savoir de quel type")"
Put_Line "$(gettext "de fichier il s'agit, utilisez la commande 'file', et")"
Put_Line "$(gettext "utilisez ensuite l'outil adapté pour l'ouvrir.")"

gettext "end Etape_D2;"
echo

gettext "etape_d2.adb genere" >&2
echo >&2

sed -ne '1,8p' $(gettext etape)_d2.adb > $(gettext etape)_d2-1.txt
unoconv --format odt $(gettext etape)_d2-1.txt

sed -ne '9,16p' $(gettext etape)_d2.adb > $(gettext etape)_d2-2.txt

sed -ne '17,$p' $(gettext etape)_d2.adb > $(gettext etape)_d2-3.txt
