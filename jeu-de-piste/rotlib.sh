. rotlib-decode.sh

full_alphabet="abcdefghijklmnopqrstuvwxyz/1234567890"
full_alphabetdecale="1234567890/abcdefghijklmnopqrstuvwxyz"

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

coder_bis () {
    tr "[abcdef1234567890xyzt]" "[1234567890xyztabcdef]"
}
