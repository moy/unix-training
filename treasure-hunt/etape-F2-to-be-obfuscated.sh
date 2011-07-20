#!/bin/bash

# execute 'exec 4<&1' before exec'ing this script!

retry () {
    if [ "$1" != "" ]; then
	hint=" ($1)."
    else
	hint=""
    fi
    echo "Non ... ${hint}"
    echo 'Rejoue !';
}

# cancel () {
#     echo "Ok j'arrête. Mais il faudra recommencer !";
#     exit 1;			# mouaif
# }

ok () {
    echo "Bravo ! fin de l'étape...

L'étape suivante se trouve sur le serveur ensilinux.imag.fr. Elle est
dans le fichier

  ~moy/etape-G1.txt

Récupérez-la via sftp (cf.
http://ensiwiki.ensimag.fr/index.php/Travailler_à_distance pour 1001
façons de faire cela) pour continuer.
"
    exit 0;
}

retry_eof () {
    retry 'cette action envoie un caractere de fin de fichier au processus'
}

retry_int () {
    retry 'cette action aurait pu tuer le processus'
}

wait_eof () {
    oneof () { ok; }
    onstp () { :; }
    oncont () { :; }
    onint () { retry_int; }
    onquit () { retry; }
    echo "Ok, je me suspends. Relance-moi en avant-plan pour continuer."
    echo "A tout de suite ...";
}

wait_stp () {
    oneof () { retry_eof; }
    onstp () {
	wait_eof; kill -STOP $$; 
	echo "Me revoila. J'attends maintenant un caractere de fin de fichier.
Si la commande avait été lancée avec une entree redirigee
(comme \"$PROG < un-fichier\" ou bien \"commande | $PROG\",
le caractere de fin de fichier aurait ete recu en arrivant
a la fin du fichier ou de la commande d'entree. Ici, l'entree de
$PROG est le clavier. On peut simuler une fin de fichier avec
Control-d.";}
    oncont () { :; }
    onint () { retry_int; }
    onquit () { retry; }
    echo 'Suspends moi...';
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

wget "http://www-verimag.imag.fr/~moy/monitoring-jdp/record.php?login=$LOGNAME&step=F2" -O /dev/null 2>/dev/null

while true; do
    while read -u 4 -r var; do :; done;
    oneof;
done;
