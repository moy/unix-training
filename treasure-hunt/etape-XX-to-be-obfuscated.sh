# execute 'exec 4<&1' before exec'ing this script!

retry () {
    echo 'Rejoue !';
}

# cancel () {
#     echo "Ok j'arrête. Mais il faudra recommencer !";
#     exit 1;			# mouaif
# }

ok () {
    echo "Bravo ! fin de l'étape...

bla bla bla";
    exit 0;
}

wait_eof () {
    oneof () { ok; }
    onstp () { :; }
    oncont () { :; }
    onint () { retry; }
    onquit () { retry; }
    echo "Ok, j'attends maintenant un caractère de fin de fichier...";
}

wait_stp () {
    oneof () { retry; }
    onstp () { wait_eof; kill -STOP $$; }
    oncont () { :; }
    onint () { retry; }
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

while true; do
    while read -u 4 -r var; do :; done;
    oneof;
done;
