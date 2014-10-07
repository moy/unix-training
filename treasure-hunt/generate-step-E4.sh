#! /bin/bash

. ./treasure-setup.sh
. ./i18n-lib.sh
. ./rotlib.sh

mkdir -p $(gettext etape)-E3/

gettext "Bien, vous avez reussi a decoder le message.

La solution la plus élégante était d'utiliser une redirection, comme
ceci :

  ./decoder < etape-E4.txt

Si on veut sauvegarder le résultat, on peut aussi écrire

  ./decoder < etape-E4.txt > etape-E4-decodee.txt

puis regarder le contenu du fichier etape-E4-decodee.txt.

Pour l'etape suivante, le message se trouve dans etape-E5.txt, mais
il est doublement code : pour le decoder, il va falloir passer dans
deux filtres differents.

Le deuxieme filtre s'appelle \"decoder_bis\", il va falloir le
compiler comme le premier.

Vous devriez, en une ligne de commande, executer quelque chose comme
cela :

fichier ----> decoder -----> decoder_bis ----> affichage

(en utilisant la notion de \"pipe\").
" | decalepipe > $(gettext etape)-E3/$(gettext etape)-E4.txt
