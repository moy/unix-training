#! /bin/bash

rm -fr etape-H5
mkdir etape-H5
cd etape-H5
git init

echo "Bonjour,

Ceci est la version initiale du fichier README.txt." > README.txt

git add README.txt; git commit -m "Version initiale"

echo "
On ajoute une ligne" >> README.txt

git commit -a -m "Version suivante"

echo "
... et encore une ligne." >> README.txt

git commit -a -m "Solution de l'étape H6.

En principe, ici, on met un texte expliquant ce qui a été fait pour cette
révision, et surtout pourquoi on l'a fait comme ça.

Une fois n'est pas coutume, on va mettre autre chose : la solution
d'une étape du jeu de piste. Pour l'étape suivante, elle se trouve
dans le fichier README.txt, un peu plus tard dans l'historique.

Avec gitk, vous devriez la trouver sans problème.
"

echo "
une dernière ligne." >> README.txt

git commit -a -m "Encore une petite modification"

echo "Voici la solution de l'étape H7.

L'étape suivante est un programme, il se trouve dans
~moy/jeu-de-piste/qyxrd/etape-H8.

Ce programme lit la réponse à l'étape suivante, mais ... il ne dit
rien de ce qu'il a lu. Il va falloir examiner un peu l'exécution du
programme pour voir à quels fichiers il doit toucher.

Deux solutions : vous documenter sur la commande 'strace', ou bien
utiliser le système de fichiers virtuel /proc/.

/proc, c'est un répertoire, mais il ne correspond pas à un emplacement
du disque dur : le système nous montre ses structures de données
internes sous forme de fichier. En particulier, pour chaque processus,
il y a un répertoire /proc/le-pid-du-processus/ qui contient un
certain nombre d'informations pertinents sur ce fichier.

Plus d'informations dans 'man proc', également disponible en ligne :
http://linux.die.net/man/5/proc .

La commande strace, quant à elle, permet de voir tous les appels
systèmes que fait un processus. En particulier, on verra donc quels
fichiers ont été ouverts avec l'appel 'open'." > README.txt

git commit -a -m "Réécriture de README.txt"

echo "Autre version" > README.txt
git commit -a -m "Autre version de README.txt"

echo "Encore une autre version" > README.txt
git commit -a -m "Encore une autre version de README.txt"

echo "Voici l'étape H5.

Ce fichier n'a rien de spécial, mais le répertoire qui le contient est
un dépôt Git, c'est à dire qu'il contient non seulement la version
courante des fichiers qu'il contient, mais aussi un historique de tout
ce qui s'est passé sur ces fichiers.

Dans la vie de tous les jours d'un informaticien, des outils comme Git
sont extrèmement pratiques pour travailler à plusieurs, éviter de
faire des bétises irréparables, ...

Pour le jeu de piste, l'étape suivante est cachée dans l'historique.
Pour explorer cet historique, lancez la commande gitk. En haut à
gauche, apparait la liste des révisions faites aux fichiers, avec un
descriptif rapide. En cliquant sur une ligne, on voit un descriptif
plus long des changements. L'étape H6 se trouve dans le descriptif
d'un de ces changements (le titre est assez explicite ...)" > README.txt

git commit -a -m "Solution etape H5"
