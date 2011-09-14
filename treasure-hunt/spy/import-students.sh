#! /bin/sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--apply		Apply SQL directly to the database
	--postgresql	Use PostgreSQL instead of MySQL
EOF
}

apply=no
group=1A

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
    first=$(echo "$line" | cut -d \; -f 4 | sed "s/'/\\\\'/g")
    last=$( echo "$line" | cut -d \; -f 5 | sed "s/'/\\\\'/g")
    echo 'INSERT INTO `hunt_student` (`login` , `group`, `first_name` , `familly_name`)'
    echo "                    VALUES ('$login', '$group', '$first',      '$last');"
done | $db_cmd
