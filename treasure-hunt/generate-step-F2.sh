#!/bin/bash

. ./treasure-setup.sh
. ./spy-lib.sh
. ./i18n-lib.sh

dest=$(gettext etape)-F2.sh

# This may be too easy to "decode", but beeing able to do that may
# also indicate that the current exercice is not useful..

exec > "$dest"

printf "%s\n" '#!/bin/bash

exec 4<&1

# We need bash here to be able to read from 4th fd directly...
# RedHat bug with base64 -d => use -i as a workaround
# https://bugzilla.redhat.com/show_bug.cgi?id=719317
base64 -di <<EOF | exec /bin/bash -s'

# Encode script (note we should take care that it does not generate any dollar sign).
base64 <<EOF
#!/bin/bash

# execute 'exec 4<&1' before exec'ing this script!

retry () {
    if [ "\$1" != "" ]; then
	hint=" (\$1)."
    else
	hint=""
    fi
    echo "$(gettext "Non ...")" "\${hint}"
    echo "$(gettext 'Rejoue !')";
}

# cancel () {
#     echo "Ok j'arrête. Mais il faudra recommencer !";
#     exit 1;			# mouaif
# }

ok () {
    echo "$(gettext "Bravo ! fin de l'étape...

L'étape suivante se trouve sur le serveur \${auxiliarymachine}. Elle est
dans le fichier

  ~\${auxiliary_user}/etape-G1.txt

Récupérez-la via sftp (cf.
http://ensiwiki.ensimag.fr/index.php/Travailler_à_distance pour 1001
façons de faire cela) pour continuer.
" | envsubst)"
    exit 0;
}

retry_eof () {
    retry "$(gettext 'cette action envoie un caractere de fin de fichier au processus')"
}

retry_int () {
    retry "$(gettext 'cette action aurait pu tuer le processus')"
}

wait_eof () {
    oneof () { ok; }
    onstp () { :; }
    oncont () { :; }
    onint () { retry_int; }
    onquit () { retry; }
    echo "$(gettext "Ok, je me suspends. Relance-moi en avant-plan pour continuer.
A tout de suite ...")";
}

wait_stp () {
    oneof () { retry_eof; }
    onstp () {
	wait_eof; kill -STOP \$\$; 
	echo "$(gettext "Me revoila. J'attends maintenant un caractere de fin de fichier.
Si la commande avait été lancée avec une entree redirigee
(comme './etape-F2.sh < un-fichier' ou bien 'commande | ./etape-F2.sh'),
le caractere de fin de fichier aurait ete recu en arrivant
a la fin du fichier ou de la commande d'entree. Ici, l'entree de
etape-F2.sh est le clavier. On peut simuler une fin de fichier avec
Control-d.
")" ; }
    oncont () { :; }
    onint () { retry_int; }
    onquit () { retry; }
    echo "$(gettext 'Suspends moi...')";
}

# wait_quit () {
#     oneof () { retry; }
#     onstp () { :; }
#     oncont () { :; }
#     onint () { retry; }
#     onquit () { wait_stp; }
#     echo 'SIGQUIT ?';
# }

# wait_int () {
#     oneof () { retry; }
#     onstp () { retry; }
#     oncont () { :; }
#     onint () { wait_quit; }
#     onquit () { retry; }
#     echo 'SIGINT ?';
# }

wait_stp;

trap 'onint' INT;
trap 'onstp' TSTP;
trap 'oncont' CONT;
trap 'onquit' QUIT;

$(monitor_step_cmd F2)

while true; do
    while read -u 4 -r var; do :; done;
    oneof;
done;
EOF

echo 'EOF'

chmod u+x "$dest"

# echo "$dest genere." >/dev/stderr
