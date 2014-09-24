mail_config () {
    cat <<EOF
emailprompt="$(gettext "Entrez votre adresse email \$school
Elle s'écrit \$example_email
" | envsubst)"
noemailcommand="$(gettext "Désolé, je n'ai pas trouvé de commande pour envoyer d'email.
Voici le contenu du message qui devait être envoyé:
")"
email_failed_msg="$(gettext "Désolé, l'envoi de mail a échoué.
Voici le contenu du message qui devait être envoyé:
")"
from_addr=$from_addr
smtp_server=$smtp_server
get_email_function=$get_email_function
check_email_function=$check_email_function
send_email_with_php=$send_email_with_php
send_email_with_php_baseurl=$send_email_with_php_baseurl
token=$token
email_ok_msg="$email_ok_msg"
EOF
    cat mail-lib-runtime.sh
}


