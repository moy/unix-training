#! /bin/bash

. adalib.sh

exec > etape_b1.adb

echo "-- Fichier source pour l'etape B1.
-- Ce programme doit etre dans un fichier etape_b1.adb
-- Compilez-le et executez-le pour continuer.

"

adawithuse

echo "procedure Etape_B1 is"
adadecode
echo "begin"

Put_Line "Bonjour,"
New_Line
Put_Line "Si vous lisez ceci, c'est que vous avez reussi l'etape B1"
Put_Line "du jeu de piste."
New_Line
Put_Line "L'etape suivante se trouve dans le fichier."
Put_Line "http://www-verimag.imag.fr/~moy/jeu-de-piste/etape-C1.tex"
New_Line
Put_Line "Cette fois-ci, c'est une fichier LaTeX. Vous pouvez le compiler"
Put_Line "avec la commande pdflatex etape-C1.tex pour obtenir un fichier PDF."

echo "end;"

echo "etape_b1.adb genere" >&2
