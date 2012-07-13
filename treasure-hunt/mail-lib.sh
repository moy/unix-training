mail_config () {
    cat <<EOF
emailprompt="$(gettext "Entrez votre adresse email Ensimag
Elle s'écrit Prenom.Nom@ensimag.imag.fr
")"
noemailcommand="$(gettext "Désolé, je n'ai pas trouvé de command pour envoyer d'email.
Voici le contenu du message qui devait être envoyé:
")"
from_addr=$from_addr
smtp_server=$smtp_server
get_email_function=$get_email_function
check_email_function=$check_email_function
EOF
    cat mail-lib-runtime.sh
}


