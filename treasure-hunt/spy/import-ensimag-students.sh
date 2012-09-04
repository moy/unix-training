#! /bin/sh

year=1a
course=1a
absyear=2012
groups="G1 G2 G3 G4 G5 G6"

get_group () {
    togrep='.*href="\([^"]*\.csv\)".*'
    wget 'http://intranet.ensimag.fr/ZENITH/affiche-groupe.php?GROUPE='${course}_$1_${absyear}'&ANNEE='${year} -O - | \
	grep "$togrep" | \
	sed -e "s/$togrep/\\1/" -e 's@\.\./@http://intranet.ensimag.fr/@' | \
	xargs -iX wget X -O - | \
	grep '^[0-9]'
}

for group in $groups; do
    get_group "$group" | ./import-students.sh --group $group --apply
done
