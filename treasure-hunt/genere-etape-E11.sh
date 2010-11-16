#! /bin/bash

# solution Geek :
# grep -vFf etape-E11-bis.txt etape-E11.txt

. ./textlib.sh

rm -f etape-E11.txt
rm -f etape-E11-bis.txt

echo "Bien.

En fait,
ca n'etait pas si dur,
il suffisait
de faire
diff etape-E11.txt etape-E11-bis.txt | \\\\
grep '^<'
(pour grep, ^ veut dire
'debut de ligne')

(et alors, quelqu'un a trouvé la commande avec seulement grep ?)

Pour l'etape suivante, elle se trouve dans l'archive tar disponible sur

~moy/jeu-de-piste/123654/etape-E12.tar.gz

C'est le fichier etape-E12.txt de l'archive. Vous savez déjà extraire une
archive tar, donc ça devrait être facile ... ou pas.
" | while read line; do
    bruit=$(make_noise)
    echo "$bruit
$line" >> etape-E11.txt
    echo "$bruit" >> etape-E11-bis.txt
done

