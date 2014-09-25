get_email_ensimag () {
    # Ensimag-specific, sorry.
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

check_email_regex () {
    printf '%s\n' "$1" | grep -q -E "$valid_email_regex"
}

get_email () {
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
	echo 'Force display, not sending email. Here is what would have been sent:'
	echo
	echo "$content"
	return
    elif [ "$send_email_with_php" = "yes" ] && [ "$send_email_with_php_url" != "" ]; then
	if [ "$HUNT_DEBUG" != "" ]; then
	    echo "Sending message with PHP"
	fi
	out=$(wget "$send_email_with_php_url?code=$token&to=$email" -q -O -)
	case $out in
	    OK*)
		:
		;;
	    *)
		echo "$out"
		error=t; echo "$email_failed_msg"
		;;
	esac
    elif command -v mutt >/dev/null; then
	if [ "$HUNT_DEBUG" != "" ]; then
	    echo "Sending message with mutt"
	fi
	printf '%s' "$content" | \
	    mutt -e "$smtp_mutt_cmd" \
	    -e "set from=\"$from_addr\"" \
	    -e "set record=\"\"" \
	    -s "$subject" "$email" || { error=t; echo "$email_failed_msg"; }
    elif command -v mail >/dev/null; then
	if [ "$HUNT_DEBUG" != "" ]; then
	    echo "Sending message with mail"
	fi
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
    else
	printf "$email_ok_msg\n" "$email"
    fi
}
