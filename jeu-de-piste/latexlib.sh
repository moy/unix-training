. rotlib.sh

latextable () {
    for lettre in a b c d e f g h i j k l m n o p q r s t u v w x y z; do
	printf "%s" '\newcommand{\A'$lettre'}[0]{'
	printf "%s" $lettre | tr "$alphabet" "$alphabetdecale"
	printf "%s\n" '}'
    done
}

latexencode () {
    tr "$alphabetdecale" "$alphabet" | sed "s/[$alphabet]/"'\\A\0{}/g'
}
