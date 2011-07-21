#! /bin/bash

. i18n-lib.sh
. adalib.sh

exec > $(gettext etape)_d1.adb

gettext -- "-- Fichier source pour l'etape D1.
-- Ce programme doit etre dans un fichier etape_d1.adb
-- Corrigez les erreurs, puis
-- compilez-le et executez-le pour continuer.

-- Le fichier est volontairement illisible pour rendre l'exercice plus
-- \"amusant\".
"

adawithuse

gettext "procedure Etape_D1 is"
adadecode
echo "begin"

Noise
Noise
Put_Line "$(gettext "Bonjour,")"
Noise
New_Line
Noise
Put_Line "$(gettext "Si vous lisez ceci, c'est probablement que vous avez reussi a")"
Put_Line "$(gettext "compiler le fichier etape_d1.adb.")"
Noise
Noise
# manque un ';'
echo
echo '   New_Line'
echo
Noise
Put_Line "$(gettext "L'etape suivante est aussi un programme Ada a compiler,")"
Noise
Put_Line "$(gettext "mais il a ete decoupe en plusieurs morceaux. Le premier est")"
Noise
Put_Line "$(gettext "dans un fichier OpenOffice qui se trouve ici :")"
Put_Line "$(gettext "http://www-verimag.imag.fr/~moy/jeu-de-piste/etape_d2-1.odt")"
Noise
Put_Line "$(gettext "Le second est dans un fichier texte qui se trouve dans")"
Noise
Put_Line "$(gettext "~moy/jeu-de-piste/etape_d2-2.txt")"
Noise
Put_Line "$(gettext "Et le dernier est ici :")"
New_Line

./generate-step-D2.sh
cat $(gettext etape)_d2-3.txt | sed 's/"/""/g' | while read line; do
    Put_Line "   $line"
done

# manque un ';'
echo
echo '   New_Line'
echo
Noise
Put_Line "$(gettext "A vous de faire les copier-coller pour remettre le tout ensemble")"
Noise

gettext "end Mauvais_Nom_Qui_Devrait_Etre_Etape_D1;
"

gettext "etape_d1.adb genere
" >&2

