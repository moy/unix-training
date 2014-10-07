#! /bin/bash

. ./rotlib.sh

error=0

for string in abcdefghijklmnopqrstuvwxyz1234567890 1234567890abcdefghijklmnopqrstuvwxyz
do
    out=$(printf '%s\n' "$string" | rotpipe | unrotpipe)
    printf '%s -> %s\n' "$string" "$out"
    if [ "$out" != "$string" ]
    then
	echo KO
	error=$((error + 1))
    fi
done

exit $error
