#! /bin/bash

. latexlib.sh

exec > etape-C1.tex

echo '
\documentclass[a4paper]{article}
\usepackage[utf8]{inputenc}
'

latextable

echo '\begin{document}'

echo "Bien, vous avez réussi à compiler le fichier.

Il faut reconnaitre que le source n'était pas très lisible (mais
rassurez-vous, il n'a pas été écrit à la main ...).

L'etape suivante se trouve dans le fichier jeu-de-piste/etape-C2.odt
sur le compte de l'utilisateur moy. Il vous reste à trouver avec
quelle application ouvrir ce fichier ..." | \
    latexencode

echo '\end{document}'
