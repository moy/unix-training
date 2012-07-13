#! /bin/bash

. ./treasure-setup.sh
. ./spy-lib.sh
. i18n-lib.sh

alphabet="abcdefghijklmnopqrstuvwxyz"
alphabetdecale="zabcdefghijklmnopqrstuvwxy"

alphabet1="abcdefghijklm"
alphabet2="nopqrstuvwxyz"
ALPHABET1="ABCDEFGHIJKLM"
ALPHABET2="NOPQRSTUVWXYZ"

rotpipe () {
    tr "${alphabet1}${alphabet2}${ALPHABET1}${ALPHABET2}" \
	"${alphabet2}${alphabet1}${ALPHABET2}${ALPHABET1}"
}

rot () {
    echo "$1" | rotpipe
}

exec > $(gettext jeu-de-piste.sh)

printf "%s\n\n" '#! /bin/bash'
chmod +x $(gettext jeu-de-piste.sh)

cat rotlib-decode.sh
cat rotlib-encode.sh
. ./mail-lib.sh
mail_config

echo 'email=$(get_email "$LOGNAME")'

printf "%s" '
echo "'

gettext "Bonjour,

Cet email vous est envoye par le script jeu-de-piste.sh. Il fait
partie du TP 'Jeu de piste'.

L'etape suivante est une compilation de programme Ada. Un programme
Ada se trouve dans le fichier etape_b1.adb dans le repertoire
jeu-de-piste sur le compte de l'utilisateur \${main_user}.

Vous n'avez pas le droit d'utiliser la commande 'ls' dans ce
repertoire (vous pouvez essayer, mais ca ne marchera pas), mais vous
pouvez tout de meme recuperer le fichier en question (vous verrez plus
tard comment utiliser la commande chmod pour obtenir ce genre de
permissions).

Recuperez ce fichier chez vous, par exemple avec

  cp le-fichier-en-question ~

(~ veut dire 'mon repertoire personnel')

Puis revenez dans votre repertoire personnel et compilez le fichier
avec la commande

  gnatmake etape_b1

puis executez-le avec

  ./etape_b1

Le programme genere vous donnera les indications pour aller a l'etape
suivante.
" | envsubst | rotpipe

echo '" | rotpipe | send_mail "'"$(gettext "Enonce etape B1")"'" "$email"'

monitor_step_cmd A5
printf 'printf "%s\n" "$email"\n' "$(eval_gettext "Un message a ete envoye a %s.
Consultez cette boite mail pour avoir les instructions pour l'etape suivante.")"
