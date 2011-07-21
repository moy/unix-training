#! /bin/bash

. ./i18n-lib.sh

alphabet="abcdefghijklmnopqrstuvwxyz"
alphabetdecale="zabcdefghijklmnopqrstuvwxy"

alphabet1="abcdefghijklm"
alphabet2="nopqrstuvwxyz"
ALPHABET1="ABCDEFGHIJKLM"
ALPHABET2="NOPQRSTUVWXYZ"


rotpipe () {
    tr "${alphabet1}${alphabet2}${ALPHABET1}${ALPHABET2}" \
	"${alphabet2}${alphabet1}${ALPHABET2}${ALPHABET1}"
}

rot () {
    echo "$1" | rotpipe
}

exec > $(gettext etape-A2.txt)

gettext "Voila, vous avez résolu l'etape A1.

Pour l'étape suivante (A2), la voici, mais elle est encodée en rot13.

Au point où vous en êtes, vous devriez être capables de trouver (en
quelques secondes) ce qu'est rot13, et un moyen de le décoder
facilement.

"

gettext "Voila, le rot13 est decode.

Si vous etes malins, vous avez sans doute remarque que le web regorge
de codeur/decodeur rot13 en ligne, donc, un bon moteur de recherche a
la main, on trouve rapidement son bonheur (et c'etait bien le but de
l'exercice !). Les Emacsiens auront prefere M-x rot13-region RET, mais
c'est une autre histoire.

Pour l'etape suivante (A3), il faudra vous rendre sur EnsiWiki :
retournez sur la page de depart du jeu de piste
(http://ensiwiki.ensimag.fr/index.php/TP_Unix_-_Jeu_de_piste),
et ouvrez l'onglet 'discussion'. On se retrouve la bas !
" | rotpipe
