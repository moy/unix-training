#! /bin/sh

printf "%s" "
\documentclass[a4paper]{article}
\usepackage[utf8]{inputenc}

\begin{document}
\large
Et oui, c'est bien un fichier PDF (si vous lisez ceci, je suppose
que vous l'avez ouvert avec un outil comme kpdf, evince ou acroread).

Pour l'étape suivante, elle se trouve dans le répertoire suivant :

\verb|~moy/jeu-de-piste/kmcv/|

C'est le seul fichier de ce répertoire, mais c'est un fichier caché,
donc, vous ne le verrez pas forcément immédiatement ...
\end{document}
" > etape-E1.tex

pdflatex etape-E1.tex
mv etape-E1.pdf etape-E1

