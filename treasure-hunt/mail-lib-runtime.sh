get_email_ensimag () {
    if command -v ldapsearch >/dev/null; then
	ldapsearch -H ldap://ensildap.imag.fr \
	    -x -b dc=ensimag,dc=imag,dc=fr uid="$1" \
            | grep "^mail:" | sed "s/^mail: *//"
    else
	echo "$1"
    fi
}

get_email_verimag () {
    grep "^alias $1 " /usr/local/common/etc/mailrc | \
	sed 's/.* //' || echo "$1"
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
    content=$(cat)
    subject="$1"
    email="$2"
    error=''
    if [ "$smtp_server" != "" ]; then
	smtp_mutt_cmd="set smtp_url=\"smtp://$smtp_server\""
    else
	smtp_mutt_cmd=""
    fi
    if [ "$HUNT_FORCE" != "" ]; then
	echo 'Force display, not sending email'
	echo "$noemailcommand"
	cat
    elif command -v mutt >/dev/null; then
	printf '%s' "$content" | \
	    mutt -e "$smtp_mutt_cmd" \
	    -e "set from=\"$from_addr\"" \
	    -e "set record=\"\"" \
	    -s "$subject" "$email" || { error=t; echo "$email_failed_msg"; }
    elif command -v mail >/dev/null; then
	printf '%s' "$content" | \
	    mail -s "$subject" "$email" || { error=t; echo "$email_failed_msg"; }
    else
	echo "$noemailcommand"
	error=t
    fi
    if [ "$error" = t ]; then
	echo
	printf '%s' "$content"
	exit 1
    fi
}
