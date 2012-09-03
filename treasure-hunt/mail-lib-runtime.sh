get_email_ensimag () {
    if command -v ldapsearch >/dev/null; then
	ldapsearch -H ldap://ensildap.imag.fr \
	    -x -b dc=ensimag,dc=imag,dc=fr uid="$1" \
            | grep "^mail:" | sed "s/^mail: *//"
    else
	echo "$1"
    fi
}

check_email_ensimag () {
    echo "$1" | grep -q \
	-e '@.*imag\.fr$' \
	-e '@.*grenoble-inp\.fr$' \
	-e '@inria.*\.fr$'
}

get_email () {
    # Ensimag-specific, sorry.
    login="$1"
    email=$("$get_email_function" "$login")
    if ! echo "$email" | grep -q @; then
	while ! "$check_email_function" "$email"
	do
	    echo "$emailprompt" >&2
	    printf "%s" "email: " >&2
	    read email
	done
    fi
    echo "$email"
}

send_mail () {
    subject="$1"
    email="$2"
    if command -v mail >/dev/null; then
	mail -s "$subject" "$email"
    elif command -v mutt >/dev/null; then
	mutt -e "set smtp_url=\"smtp://$smtp_server\"" \
	    -e "set from=\"$from_addr\"" \
	    -e "set record=\"\"" \
	    -s "$subject" "$email"
    else
	echo "$noemailcommand"
	cat
	exit 1
    fi
}
