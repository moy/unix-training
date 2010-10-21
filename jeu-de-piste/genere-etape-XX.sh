#!/bin/sh

src=etape-XX-to-be-obfuscated.sh
dest=etape-XX.sh

exec > "$dest"

printf "%s\n" '#!/bin/sh

exec 4<&1

# This may be too easy to "decode", but beeing able to do that may
# also indicate that the current exercice is not useful..

# We need bash here to be able to read from 4th fd directly...  
base64 -d <<EOF | exec /bin/bash -s'

# Encode script (note we should take care that it does not generate any dollar sign).
base64 < "$src"

echo 'EOF'

chmod u+x "$dest"

# echo "$dest genere." >/dev/stderr
