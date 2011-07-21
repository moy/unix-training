#! /bin/bash

# solution Geek :
# grep -vFf etape-E11-bis.txt etape-E11.txt

. ./i18n-lib.sh
. ./textlib.sh

rm -f $(gettext etape)-E11.txt
rm -f $(gettext etape)-E11-bis.txt

gettext "Bien.

En fait,
ca n'etait pas si dur,
il suffisait
de faire

  diff etape-E11.txt etape-E11-bis.txt | grep '^<'

(pour grep, ^ veut dire 'debut de ligne')

(et alors, quelqu'un a trouvé la commande avec seulement grep ?)

Pour l'étape suivante, on va s'entrainer au futur examen de TP. Une version de démonstration est disponible ici :

http://www-verimag.imag.fr/~moy/demo-exam-ensimag2011/

Répondez correctement à toutes les questions, puis suivez les
instructions en bas de page.

La réponse à la dernière question sera : b3147554

" | while read line; do
    bruit=$(make_noise)
    echo "$bruit
$line" >> $(gettext etape)-E11.txt
    echo "$bruit" >> $(gettext etape)-E11-bis.txt
done

