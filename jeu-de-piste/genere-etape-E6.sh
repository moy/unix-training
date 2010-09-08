#! /bin/bash

. dirlib.sh

rm -fr etape-E6
mkdir -p etape-E6/
cd etape-E6 || (echo "echec"; exit 1) || exit 1

top=$(pwd)

E7_dir=$RANDOM/$(uuid)/$(uuid)/
E8_dir=$RANDOM/$(uuid)/$(uuid)/
E9_dir=$RANDOM/$(uuid)/$(uuid)/

make_big_dir 20

# for dir in */*/; do
#     cd "$dir"
#     for i in $(seq $(($RANDOM % 10))); do
#         if [ $(($RANDOM % 100)) -eq 1 ]; then
#             E7_dir="$dir"
#         elif [ $(($RANDOM % 100)) -eq 1 ]; then
#             E8_dir="$dir"
#         elif [ $(($RANDOM % 100)) -eq 1 ]; then
#             E9_dir="$dir"
#         fi
#         uuid > $(uuid)
#     done
#     cd "$top"
# done

mkdir -p "$E7_dir"
make_subdirs_back "$E7_dir"

mkdir -p "$E8_dir"
make_subdirs_back "$E8_dir"

mkdir -p "$E9_dir"
make_subdirs_back "$E9_dir"

echo "Bravo,

Enfin, en esperant que vous n'ayez pas examine tous les fichiers un
par un, mais que vous ayez utilise une commande comme

  find . -name '*.txt' ...

L'etape suivante se trouve aussi dans
/home/perms/moy/jeu-de-piste/kmcvoaue/etape-E6/.

C'est le plus gros fichier qui se trouve dans ce repertoire ou un de
ses sous-repertoires.

(les commandes find et sort peuvent vous aider. Regardez en
particulier l'option -exec de find ou bien documentez-vous sur la
commande xargs)" \
    > "$E7_dir"/$(uuid | sed 's/....$//').txt

echo "Bien vu !

Vous avez fait comment ? Moi, je m'en suis sorti avec

  find etape-E6/ -type f | xargs ls -l | sort -n -k 5 | tail -n 1

mais chacun ses gouts. On peut aussi s'en sortir a coups de

  ls -lR etape-E6/ | sort -n -k 5

ou (sans doute plus propre) :

  find etape-E6/ -type f -exec wc -c {} \; | sort -n

Vous pouvez aller chercher l'etape E8, c'est le seul fichier (a part
celui-ci) du repertoire qui contienne la chaine :

  Bravo, vous avez trouve l'etape E8.

Bon, on avait dit qu'il fallait que ce soit le plus gros fichier du
repertoire, donc il faut meubler un peu pour que le fichier soit
effectivement gros. Donc, pour prendre un peu de place, voici un Tux
en ascii-art :

                 .88888888:.
                88888888.88888.
              .8888888888888888.
              888888888888888888
              88' _\`88'_  \`88888
              88 88 88 88  88888
              88_88_::_88_:88888
              88:::,::,:::::8888
              88\`:::::::::'\`8888
             .88  \`::::'    8:88.
            8888            \`8:888.
          .8888'             \`888888.
         .8888:..  .::.  ...:'8888888:.
        .8888.'     :'     \`'::\`88:88888
       .8888        '         \`.888:8888.
      888:8         .           888:88888
    .888:88        .:           888:88888:
    8888888.       ::           88:888888
    \`.::.888.      ::          .88888888
   .::::::.888.    ::         :::\`8888'.:.
  ::::::::::.888   '         .::::::::::::
  ::::::::::::.8    '      .:8::::::::::::.
 .::::::::::::::.        .:888:::::::::::::
 :::::::::::::::88:.__..:88888:::::::::::'
  \`'.:::::::::::88888888888.88:::::::::'
        \`':::_:' -- '' -'-' \`':_::::'\`
" > "$E8_dir"/$(uuid)

echo "Bravo, vous avez trouve l'etape E8.

Pour l'étape suivante, elle se trouve à l'adresse

http://www-verimag.imag.fr/~moy/jeu-de-piste/yntsf/etape-E10.txt
" \
    > "$E9_dir"/$(uuid)
