#! /bin/bash

. ./treasure-setup.sh
. i18n-lib.sh
. adalib.sh

exec > $(gettext etape)_d1.adb

gettext "Fichier source pour l'etape D1.
Ce programme doit etre dans un fichier etape_d1.adb
Corrigez les erreurs, puis
compilez-le et executez-le pour continuer.

Le fichier est volontairement illisible pour rendre l'exercice plus
\"amusant\".
" | ada_comment_out

adawithuse

gettext "procedure Etape_D1 is"
adadecode
echo "begin"

gettext "Bonjour,

Si vous lisez ceci, c'est probablement que vous avez reussi a
compiler le fichier etape_d1.adb.
" | ada_obfuscate Noise

Noise
# missing ';'
echo
echo '   New_Line'
echo
Noise

gettext "L'etape suivante est aussi un programme Ada a compiler,
mais il a ete decoupe en plusieurs morceaux. Le premier est
dans un fichier OpenDocument (LibreOffice, OpenOffice.org, ...) qui se
trouve ici :

  \$web_url/etape_d2-1.odt

Le second est dans un fichier texte qui se trouve dans

  \$maindir_tilde/etape_d2-2.txt

Et le dernier est ici :
" | envsubst | ada_obfuscate Noise

./generate-step-D2.sh
cat $(gettext etape)_d2-3.txt | sed 's/"/""/g' | ada_obfuscate

# missing ';'
echo
echo '   New_Line'
echo
Noise
gettext "A vous de faire les copier-coller pour remettre le tout ensemble" | ada_obfuscate
Noise

gettext "end Mauvais_Nom_Qui_Devrait_Etre_Etape_D1;
"

gettext "etape_d1.adb genere
" >&2

