#! /bin/bash

. rotlib.sh

echo "Bravo !

L'etape suivante se trouve sur telesun, dans le repertoire
/home/perms/moy/jeu-de-piste/kmcvoaue/etape-E6/
Les instructions sont dans le seul fichier de ce repertoire dont le
nom se termine par .txt." | \
    tr "[abcdef1234567890xyzt]" "[1234567890xyztabcdef]" | \
    decalepipe > etape-E3/etape-E5.txt
