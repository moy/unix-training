#! /bin/bash

rm -fr F1/
rm -f etape-E13.txt

echo "Voila, vous terminez ainsi la partie E du jeu de piste.

L'étape suivante se trouve dans le répertoire F1 de ce répertoire
(dans la même archive etape-E13.tar.gz).

C'est le seul fichier dont le nom commence par x, et terminant par
autre chose qu'un z.
" > etape-E13.txt


mkdir -p F1
cd F1
for i in $(seq 100); do
    echo $RANDOM > $(echo $RANDOM | tr '[0-9]' '[a-j]')
done

for i in $(seq 100); do
    echo $RANDOM > x$(echo $RANDOM | tr '[0-9]' '[a-j]')z
done

echo "Oui, c'est bien celui là.

L'étape suivante se trouve sur ensibull. Elle est dans le fichier
~moy/etape-G1.txt. Récupérez-la via sftp (cf.
http://ensiwiki.ensimag.fr/index.php/Travailler_à_distance pour 1001
façons de faire cela) pour continuer. " > xabcdefg1

cd ..

tar czvf etape-E13.tar.gz --mode 000 etape-E13.txt F1/
