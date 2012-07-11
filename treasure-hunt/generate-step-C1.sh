#! /bin/bash

. ./treasure-setup.sh
. i18n-lib.sh
. latexlib.sh

exec > $(gettext etape)-C1.tex

echo '
\documentclass[a4paper]{article}
\usepackage[utf8]{inputenc}
'

latextable

echo '\begin{document}'

gettext "Bien, vous avez réussi à compiler le fichier.

Il faut reconnaitre que le source n'était pas très lisible (mais
rassurez-vous, il n'a pas été écrit à la main ...).

L'etape suivante se trouve dans le fichier jeu-de-piste/etape-C2.odt
sur le compte de l'utilisateur \${main_user}. Il vous reste à trouver avec
quelle application ouvrir ce fichier ..." | \
    envsubst | latexencode

echo '\end{document}'
