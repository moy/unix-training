if command -v uuid >/dev/null 2>/dev/null; then
    : Nothing to do
elif command -v uuidgen >/dev/null 2>/dev/null; then
    uuid () {
	uuidgen
    }
else
    echo "Warning: cannot find uuid or uuidgen. Using built-in (simple) one." >&2
    # we don't need secure random, so at worse, bash's $RANDOM will do.
    uuid () {
	echo $RANDOM | sha1sum | \
	    sed 's/\(........\)\(....\)\(....\)\(....\)\(............\).*/\1-\2-\3-\4-\5/'
    }
fi
