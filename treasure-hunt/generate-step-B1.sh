#! /bin/bash

. adalib.sh
. i18n-lib.sh

exec > $(gettext etape)_b1.adb

gettext -- "-- Fichier source pour l'etape B1.
-- Ce programme doit etre dans un fichier etape_b1.adb
-- Compilez-le et executez-le pour continuer.

"

adawithuse

gettext "procedure Etape_B1 is"
adadecode
echo "begin"

Put_Line "$(gettext "Bonjour,")"
New_Line
Put_Line "$(gettext "Si vous lisez ceci, c'est que vous avez reussi l'etape B1")"
Put_Line "$(gettext "du jeu de piste.")"
New_Line
Put_Line "$(gettext "L'etape suivante se trouve dans le fichier.")"
Put_Line "$(gettext "http://www-verimag.imag.fr/~moy/jeu-de-piste/etape-C1.tex")"
New_Line
Put_Line "$(gettext "Cette fois-ci, c'est une fichier LaTeX. Vous pouvez le compiler")"
Put_Line "$(gettext "avec la commande pdflatex etape-C1.tex pour obtenir un fichier PDF.")"

echo "end;"

echo $(gettext etape)_b1.adb "generated" >&2
