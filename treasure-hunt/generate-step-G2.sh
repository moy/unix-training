#! /bin/bash

. ./treasure-setup.sh
. ./spy-lib.sh
. ./rotlib.sh
. ./i18n-lib.sh

exec > $(gettext etape)-G2.sh

printf "%s\n\n" '#!/bin/bash'

cat ./rotlib-decode.sh

cat <<EOF
die_rotpipe () { echo "\$@" | unrotpipe; exit 1; }
[ -z "\$SSH_CLIENT" ] && die_rotpipe "$(gettext "Il semble que vous ne soyez pas connectes à la machine via SSH.

Je refuse de m'exécuter dans ces conditions, désolé.
Merci de vous connecter à cette machine via SSH, et je
vous donnerai la solution.

Si cette étape se trouve sur la même machine que votre machine de
travail habituel, vous pouvez utiliser un PC individuel ou votre
machine personnelle pour réaliser cette étape.
" | rotpipe)"
[ -z "\$DISPLAY" ] && die_rotpipe "$(gettext "Vous n'avez pas activé l'affichage graphique avec SSH.

Réessayez en utilisant l'option -X de SSH pour activer le 'X11 forwarding'." \
	| rotpipe)"
EOF

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

'"$(monitor_step_cmd G2)"'

LANG=en_US.UTF-8 LESS= xterm -e less /tmp/tmp-G2.$$ || \
LANG=en_US.UTF-8 LESS= gnome-terminal -e less /tmp/tmp-G2.$$
rm -f /tmp/tmp-G2.$$
'

chmod +x $(gettext etape)-G2.sh
