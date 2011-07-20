#! /bin/bash

. adalib.sh

exec > etape_d2.adb

echo "-- Fichier source pour l'etape D2.
-- Le programme est coupé en 3 morceaux.
-- Assemblez-les puis compilez le programme.

"
adawithuse

echo "procedure Etape_D2 is"
adadecode
echo "begin"

Put_Line "Visiblement, le copier-coller a marché !"
New_Line
Put_Line "L'etape suivante se trouve dans le fichier"
New_Line
Put_Line "~moy/jeu-de-piste/oaue/etape-E1"
New_Line
Put_Line "La personne qui a créé ce fichier l'a nommé étrangement :"
Put_Line "il n'a pas mis d'extension (i.e. le nom de fichier ne se "
Put_Line "termine pas par .quelquechose). Pour savoir de quel type"
Put_Line "de fichier il s'agit, utilisez la commande 'file', et"
Put_Line "utilisez ensuite l'outil adapté pour l'ouvrir."

echo "end Etape_D2;"

echo "etape_d2.adb genere" >&2

sed -ne '1,8p' etape_d2.adb > etape_d2-1.txt
unoconv --format odt etape_d2-1.txt

sed -ne '9,16p' etape_d2.adb > etape_d2-2.txt

sed -ne '17,$p' etape_d2.adb > etape_d2-3.txt
