get_email () {
    # Ensimag-specific, sorry.
    login="$1"
    if command -v ldapsearch 2>/dev/null; then
	email=$(ldapsearch -H ldap://ensildap.imag.fr \
	    -x -b dc=ensimag,dc=imag,dc=fr uid="$login" \
            | grep "^mail:" | sed "s/^mail: *//")
    elif ! echo "$email" | grep -q @; then
	while ! echo "$email" | grep -q \
	    -e '@.*imag\.fr' \
	    -e '@.*grenoble-inp.fr'
	do
	    echo "$emailprompt" >&2
	    printf "%s" "email: " >&2
	    read email
	done
    fi
    echo "$email"
}

send_mail () {
    # Ensimag-specific, sorry.
    subject="$1"
    email="$2"
    if command -v mail >/dev/null; then
	mail -s "$subject" "$email"
    elif command -v mutt >/dev/null; then
	mutt -e 'set smtp_url="smtp://telesun.imag.fr"' \
	    -e 'set from="Matthieu.Moy@imag.fr"' \
	    -s "$subject" "$email"
    else
	echo "$noemailcommand"
	cat
	exit 1
    fi
}
