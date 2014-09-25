#! /bin/bash

. ./treasure-setup.sh
. ./i18n-lib.sh

rm -fr F1/
rm -f $(gettext etape)-E13.txt

gettext "Voila, vous terminez ainsi la partie E du jeu de piste.

L'étape suivante se trouve dans le répertoire F1 de ce répertoire
(dans la même archive etape-E13.tar.gz).

C'est le seul fichier dont le nom commence par x, et terminant par
autre chose qu'un z.

La solution est très simple si on sait ce qu'est un wildcard (le
polycopié vous l'apprendra si vous ne le savez pas déjà).
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

Beaucoup d'entre vous tentent des solutions bien compliquées comme

  ls | grep '^x.*[^z]\$'

C'est une assez mauvaise idée pour plusieurs raisons : d'une part, la
sortie de 'ls' n'est pas faite pour être lue par une commande ('grep'
ici) mais par un être humain. Si votre 'ls' est configuré pour
afficher des caractères en plus (e.g. @ pour les liens, / pour les
répertoires, ...) alors ces caractères sont lus par 'grep' par exemple.
D'autre part, on utilise deux processus ('ls' et 'grep') alors qu'un
aurait suffit. Et puis, l'argument de 'grep' est une expression
régulière (vous apprendrez bientôt ce que c'est en théorie des
langages), c'est très puissant mais un peu lourd à utiliser (par
exemple, * ne veut pas dire « n'importe quelle chaîne », mais
« caractère précédent répété un nombre quelconque de fois »).

Une solution plus simple :

  ls x*[^z]

Cette fois-ci, c'est le shell et non grep qui interprête ce x*[^z]
(qui est un wildcard et non une expression régulière). Et comme c'est
le shell et non la commande ls qui fait le travail, on peut même
écrire directement :

  less x*[^z]

Pour afficher le fichier avec la commande 'less' en une ligne.

Pour l'étape suivante, exécutez (sur votre machine de travail) le script

  \$maindir_tilde/979b5c3/etape-F2.sh

et laissez-vous guider par les instructions. Le chapitre 8 du
polycopié devrait vous aider.
" | envsubst > xabcdefg1

cd ..

tar czvf $(gettext etape)-E13.tar.gz \
    --mode 000 $(gettext etape)-E13.txt F1/
