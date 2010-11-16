
alphabet1="abcdefghijklm"
alphabet2="nopqrstuvwxyz"
ALPHABET1="ABCDEFGHIJKLM"
ALPHABET2="NOPQRSTUVWXYZ"

unrotpipe () {
    tr "${alphabet2}${alphabet1}${ALPHABET2}${ALPHABET1}" \
      "${alphabet1}${alphabet2}${ALPHABET1}${ALPHABET2}"
}
