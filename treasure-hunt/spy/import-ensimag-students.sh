#! /bin/sh

absyear=2014
groups="ori_ast2a 1a_g1 1a_g2 1a_g3 1a_g4 1a_g5 1a_g6 1a_g7 1a_g8 1aa phelma ri_ech"


get_group () {
    togrep='.*href="\([^"]*\.csv\)".*'
    wget 'https://intranet.ensimag.fr/Zenith2/getGroupsCoursCsv?name='$1'_'$absyear -O - | \
	grep '^[0-9]'
}

for group in $groups; do
    get_group "$group" | ./import-students.sh --group $group --apply
done
