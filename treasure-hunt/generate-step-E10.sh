#! /bin/bash

. ./treasure-setup.sh
. i18n-lib.sh
. textlib.sh

exec > $(gettext etape)-E10.txt

gettext "Voila donc l'etape E10.

Bon, les instructions sont bien dans ce fichier, mais elles sont
melangees avec des tas d'autres lignes qui n'ont rien a voir.

Ne gardez que les lignes qui contiennent la chaine ETAPE-E10 pour
avoir les bonnes instructions.
"

gettext "Pour l'etape suivante
les instructions
se trouvent
dans le fichier
etape-E11.txt
dans le
meme repertoire
que le fichier
de l'etape
E10.

Pour l'obtenir
il suffit donc
dans votre navigateur
d'editer l'URL de
l'etape E10 et de
remplacer etape-E10.txt
par etape-E11.txt

(enfin, pour telecharger des fichiers
rapidement, il y a aussi wget:

wget http://blabla.com/fichier

va telecharger le fichier dans le
répertoire courant)

par contre, cette etape est encore
polluee par des lignes inutiles.
En fait, les lignes pertinentes sont celles
qui sont dans etape-E11.txt
mais pas dans etape-E11-bis.txt
(etape-E11-bis.txt se trouve dans
le meme repertoire que les deux
autres fichiers)

La commande diff devrait vous aider.

Les plus 'Geek' d'entre vous s'en sortiront
avec seulement la commande grep, ceci dit.

" | while read line; do
    printf "%s                                       %s\n" "$line" "$(gettext ETAPE-E10)"
    make_noise
done

