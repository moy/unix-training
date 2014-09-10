#! /bin/sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--apply		Apply SQL directly to the database
	--postgresql	Use PostgreSQL instead of MySQL
	--group	GROUP	Group to use (default=1A)
EOF
}

apply=no
group=1A
mode=insert

while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
        "--postgresql")
	    exam_dbtype=postgresql
            ;;
	"--apply")
	    apply=yes
	    ;;
	"--group")
	    shift
	    group="$1"
	    ;;
	"--update")
	    mode=update
	    ;;
	*)
            echo "unrecognized option $1"
            usage
            exit 1
            ;;
    esac
    shift
done

. ./spy-lib.sh

grep '[0-9].*;.*;.*;.*;.*;' | while read line; do
    login=$(echo "$line" | cut -d \; -f 2 | sed "s/'/\\\\'/g")
    first=$(echo "$line" | cut -d \; -f 3 | sed "s/'/\\\\'/g")
    last=$( echo "$line" | cut -d \; -f 4 | sed "s/'/\\\\'/g")
    case $mode in
	"insert")
	    echo 'INSERT INTO `hunt_student'"$exam_suffix"'` (`login` , `group`, `first_name` , `familly_name`)'
	    echo "                    VALUES ('$login', '$group', '$first',      '$last');"
	    ;;
	"update")
	    echo "UPDATE \`hunt_student$exam_suffix\` SET \`group\`='$group', \`first_name\`='$first' , \`familly_name\`='$last'"
	    echo "WHERE \`login\`='$login';"
	    ;;
	*)
	    echo "No such mode $mode." 1>&2
	    exit 1
	    ;;
    esac
done | $db_cmd
