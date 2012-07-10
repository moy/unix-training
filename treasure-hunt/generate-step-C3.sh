#! /bin/bash

. ./treasure-setup.sh
. ./i18n-lib.sh
. ./imglib.sh

gettext "Voilà, cette image est une image au format PNG.

On peut l'éditer avec The Gimp (commande gimp), la
visualiser avec Eye of Gnome (commande eog), par
exemple.

Pour les curieux, vous remarquerez que l'image
ressemble à ce que produit l'utilitaire a2ps. Ce n'est
pas une coincidence, il a été généré avec a2ps et
convert pour passer du format ps au format PNG.

Nous pouvons maintenant passer à la partie sur les
éditeurs de textes.

Vous trouverez l'étape suivante dans le fichier

\$web_url/abc/etape_d1.adb

Malheureusement, cette fois-ci, le fichier n'est pas
directement compilable. Il faudra corriger quelques
erreurs de syntaxes.

Il est conseillé d'utiliser Emacs (ou un autre bon
éditeur de texte) pour cette partie : avec la commande
Goto Line décrite sur le Wiki, vous pourrez trouver
l'endroit de chaque erreur de syntaxe en un clin
d'oeil.

" | envsubst | txt2img $(gettext etape)-C3.png

gettext "etape-C3.png générée"
echo
