#! /bin/bash

. ./i18n-lib.sh

rm -fr F1/
rm -f $(gettext etape)-E13.txt

gettext "Voila, vous terminez ainsi la partie E du jeu de piste.

L'étape suivante se trouve dans le répertoire F1 de ce répertoire
(dans la même archive etape-E13.tar.gz).

C'est le seul fichier dont le nom commence par x, et terminant par
autre chose qu'un z.
" > $(gettext etape)-E13.txt


mkdir -p F1
cd F1
for i in $(seq 100); do
    echo $RANDOM > $(echo $RANDOM | tr '[0-9]' '[a-j]')
done

for i in $(seq 100); do
    echo $RANDOM > x$(echo $RANDOM | tr '[0-9]' '[a-j]')z
done

gettext "Oui, c'est bien celui là.

Pour l'étape suivante, exécutez (sur telesun) le script

  ~moy/jeu-de-piste/979b5c3/etape-F2.sh

et laissez-vous guider par les instructions. Le chapitre 8 du
polycopié devrait vous aider." > xabcdefg1

cd ..

tar czvf $(gettext etape)-E13.tar.gz \
    --mode 000 $(gettext etape)-E13.txt F1/
