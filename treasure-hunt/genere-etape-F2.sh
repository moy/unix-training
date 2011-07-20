#!/bin/bash

src=etape-F2-to-be-obfuscated.sh
dest=etape-F2.sh

# This may be too easy to "decode", but beeing able to do that may
# also indicate that the current exercice is not useful..

exec > "$dest"

printf "%s\n" '#!/bin/bash

# Within the script, $0 will be /bin/bash => save it now
export PROG=$0

exec 4<&1

# We need bash here to be able to read from 4th fd directly...
# RedHat bug with base64 -d => use -i as a workaround
# https://bugzilla.redhat.com/show_bug.cgi?id=719317
base64 -di <<EOF | exec /bin/bash -s'

# Encode script (note we should take care that it does not generate any dollar sign).
base64 < "$src"

echo 'EOF'

chmod u+x "$dest"

# echo "$dest genere." >/dev/stderr
