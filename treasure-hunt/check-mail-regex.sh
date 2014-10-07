#!/bin/sh

. ./treasure-setup.sh
. ./mail-lib-runtime.sh

error=0

for e in $valid_email_examples
do
    if check_email_regex "$e"
    then
	echo "Address $e valid: OK"
    else
	echo "Address $e invalid: KO"
	error=$((error + 1))
    fi
done

for e in $invalid_email_examples
do
    if ! check_email_regex "$e"
    then
	echo "Address $e invalid: OK"
    else
	echo "Address $e valid: KO"
	error=$((error + 1))
    fi
done

exit $error
