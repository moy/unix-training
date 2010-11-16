#! /bin/bash

. rotlib.sh

echo "Bien, vous avez reussi a decoder le message.

Pour l'etape suivante, le message se trouve dans etape-E5.txt, mais
il est doublement code : pour le decoder, il va falloir passer dans
deux filtres differents.

Le deuxieme filtre s'appelle \"decoder_bis\", il va falloir le
compiler comme le premier.

Vous devriez, en une ligne de commande, executer quelque chose comme
cela :

fichier ----> decoder -----> decoder_bis ----> affichage

(en utilisant la notion de \"pipe\")." | \
    decalepipe > etape-E3/etape-E4.txt
