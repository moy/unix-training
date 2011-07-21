#! /bin/bash

. ./adalib.sh
. ./i18n-lib.sh

exec > $(gettext etape)_b1.adb

gettext "Fichier source pour l'etape B1.
Ce programme doit etre dans un fichier etape_b1.adb
Compilez-le et executez-le pour continuer.

" | ada_comment_out

adawithuse

gettext "procedure Etape_B1 is"
adadecode
echo "begin"

gettext "Bonjour,

Si vous lisez ceci, c'est que vous avez reussi l'etape B1
du jeu de piste.

L'etape suivante se trouve dans le fichier.
http://www-verimag.imag.fr/~moy/jeu-de-piste/etape-C1.tex

Cette fois-ci, c'est une fichier LaTeX. Vous pouvez le compiler
avec la commande pdflatex etape-C1.tex pour obtenir un fichier PDF.
" | ada_obfuscate

echo "end;"

echo $(gettext etape)_b1.adb "generated" >&2
