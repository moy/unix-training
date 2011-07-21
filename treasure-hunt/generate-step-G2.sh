#! /bin/bash

. ./rotlib.sh
. ./i18n-lib.sh

exec > $(gettext etape)-G2.sh

printf "%s\n\n" '#!/bin/bash'

cat ./rotlib-decode.sh

printf "%s" '
echo '\"

gettext "Cette étape termine la partie principale du jeu de piste.

Les étapes qui suivent sont des étapes en plus, a priori plus
difficiles. Si vous vous arretez-là et que vous avez lu le polycopié
en entier, vous devriez avoir appris l'essentiel.

Pour confirmer que vous êtes arrivés jusqu'ici, nous vous demandons
d'ajouter un commentaire sur la page de discussion de la page « Jeu de
piste » du Wiki, pour permettre à l'équipe enseignante d'avoir une
idée du nombre d'étudiants qui sont arrivés au bout, et surtout pour
savoir si ça vous a plu !

La fenêtre dans laquelle s'affiche ce message est en fait le programme
'less' qui tourne dans un terminal. Vous pouvez quitter en appuyant sur
'q'.

Si vous souhaitez faire la deuxième partie du jeu de piste,
rendez-vous sur la page
http://ensiwiki.ensimag.fr/index.php/TP_Unix_-_Jeu_de_piste
et lisez l'énoncé de l'étape H1.

Sinon, vous pourrez bien sûr y revenir plus tard, par exemple pendant
le cours d'Unix avancé si vous êtes en 1A Ensimag.
" | rotpipe

printf "%s" \"'| unrotpipe > /tmp/tmp-G2.$$

wget "http://www-verimag.imag.fr/~moy/monitoring-jdp/record.php?login=$LOGNAME&step=G2" -O /dev/null 2>/dev/null

LANG=en_US.UTF-8 LESS= xterm -e less /tmp/tmp-G2.$$ || \
LANG=en_US.UTF-8 LESS= gnome-terminal -e less /tmp/tmp-G2.$$
rm -f /tmp/tmp-G2.$$
'
