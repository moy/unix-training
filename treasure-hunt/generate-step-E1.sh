#! /bin/bash

. ./treasure-setup.sh
. i18n-lib.sh

(
printf "%s" "
\documentclass[a4paper]{article}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}

\begin{document}
\large
"

gettext "Et oui, c'est bien un fichier PDF (si vous lisez ceci, je suppose
que vous l'avez ouvert avec un outil comme kpdf, evince ou acroread).

Pour l'étape suivante, elle se trouve dans le répertoire suivant :

\\verb|\${maindir_tilde}/kmcv/|

Il y a un fichier par langue (français, anglais), mais ces fichiers
sont cachés, donc, vous ne les verrez pas forcément immédiatement ...

" | envsubst

echo '\end{document}'
) > $(gettext etape)-E1.tex

pdflatex $(gettext etape)-E1.tex
mv $(gettext etape)-E1.pdf $(gettext etape)-E1

