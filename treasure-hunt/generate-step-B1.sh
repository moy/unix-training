#! /bin/bash

. ./treasure-setup.sh
. ./c-lib.sh
. ./adalib.sh
. ./i18n-lib.sh


body=$(gettext "Bonjour,

Si vous lisez ceci, c'est que vous avez reussi l'etape B1
du jeu de piste.

L'etape suivante se trouve dans le fichier.
\$web_url/etape-C1.tex

Cette fois-ci, c'est un fichier LaTeX. LaTeX est un format de fichier
qui permet de faire de jolis documents avec une mise en page
automatique. Vous pouvez compiler ce fichier avec la commande

  pdflatex etape-C1.tex

pour obtenir un fichier PDF, que vous ouvrirez ensuite avec le
logiciel aproprie.
" | envsubst)

(
gettext "Fichier source pour l'etape B1.
Compilez-le et executez-le pour continuer.

" | c_comment_out

c_dprint_header
echo "$body" | c_obfuscate_full

) > $(gettext etape)_b1.c

echo $(gettext etape)_b1.c "generated" >&2


(
gettext "Fichier source pour l'etape B1.
Ce programme doit etre dans un fichier etape_b1.adb
Compilez-le et executez-le pour continuer.

" | ada_comment_out
adawithuse
gettext "procedure Etape_B1 is"
adadecode
echo "begin"
echo "$body" | ada_obfuscate
echo "end;"
) > $(gettext etape)_b1.adb

echo $(gettext etape)_b1.adb "generated" >&2
