# TODO: merge it with `rotlib-decode.sh' into `rotlib.sh'?

# more script-proof, but could be better with some sed stuff.
      full_alphabet="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\n(){}!:;/_1234567890# \t\$"
full_alphabetdecale="1234567890# /_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ(){}!:;\n\$\t"

alphabet="abcdefghijklmnopqrstuvwxyz"
alphabetdecale="zabcdefghijklmnopqrstuvwxy"

rotpipe () {
    tr "${alphabet1}${alphabet2}${ALPHABET1}${ALPHABET2}" \
	"${alphabet2}${alphabet1}${ALPHABET2}${ALPHABET1}"
}

rot () {
    echo "$1" | rotpipe
}

decalepipe () {
    tr "[${full_alphabet}]" "[${full_alphabetdecale}]"
}

undecalepipe () {
    tr "[${full_alphabetdecale}]" "[${full_alphabet}]"
}

coder_bis () {
    tr "[abcdef1234567890xyzt]" "[1234567890xyztabcdef]"
}
