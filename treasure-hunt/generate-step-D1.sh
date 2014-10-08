#! /bin/bash

. ./treasure-setup.sh
. i18n-lib.sh
. c-lib.sh
. adalib.sh

header=$(gettext "Fichier source pour l'etape D1.
Ce programme doit etre dans un fichier etape_d1.adb
Corrigez les erreurs, puis
compilez-le et executez-le pour continuer.

Le fichier est volontairement illisible pour rendre l'exercice plus
\"amusant\".
")

part1=$(gettext "Bonjour,

Si vous lisez ceci, c'est probablement que vous avez reussi a
compiler le fichier etape_d1.adb.
")

part2=$(gettext "L'etape suivante est aussi un programme %s a compiler,
mais il a ete decoupe en plusieurs morceaux. Le premier est
dans un fichier OpenDocument (LibreOffice, OpenOffice.org, ...) qui se
trouve ici :

  \$web_url/etape_d2-1%s.odt

Le second est dans un fichier texte qui se trouve dans

  \$maindir_tilde/etape_d2-2%s.txt

Et le dernier est ici :
\\n\\n
" | envsubst)

./generate-step-D2.sh
part_d2_ada=$(sed 's/"/""/g' $(gettext etape)_d2-3-ada.txt)
part_d2_c=$(sed 's/"/\"/g' $(gettext etape)_d2-3-c.txt)

part3=$(gettext "A vous de faire les copier-coller pour remettre le tout ensemble")

(
    echo "$header" | ada_comment_out

    adawithuse

    gettext "procedure Etape_D1 is"
    adadecode
    echo "begin"


    echo "$part1" | ada_obfuscate Noise

    Noise
    # missing ';'
    echo
    echo '   New_Line'
    echo
    Noise

    printf "$part2" Ada -ada -ada | ada_obfuscate Noise

    echo "$part_d2_ada" | ada_obfuscate

    # missing ';'
    echo
    echo '   New_Line'
    echo
    Noise

    echo "$part3" | ada_obfuscate
    Noise

    gettext "end Mauvais_Nom_Qui_Devrait_Etre_Etape_D1;
"
) > $(gettext etape)_d1.adb

gettext "etape_d1.adb genere
" >&2

(
    echo "$header" | c_comment_out

    c_dprint_header

    echo "int main(void)"
    echo "{"

    echo "$part1" | c_obfuscate

    # missing ';'
    echo
    echo '	dprint("")'
    echo

    printf "$part2" C -c -c | c_obfuscate

    echo "$part_d2_c" | c_obfuscate

    # missing ';'
    echo
    echo '	dprint("")'
    echo

    echo "$part3" | c_obfuscate

    gettext "] /* Ce crochet devrait être une accolade */
"
) > $(gettext etape)_d1.c

gettext "$(gettext etape)_d1.c genere
" >&2

