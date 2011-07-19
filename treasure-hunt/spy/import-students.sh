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
    login=$(echo "$line" | cut -d \; -f 2)
    first=$(echo "$line" | cut -d \; -f 4)
    last=$( echo "$line" | cut -d \; -f 5)
    echo 'INSERT INTO `hunt_student` (`login` , `first_name` , `familly_name`)'
    echo "                    VALUES ('$login', '$first',      '$last');"
done | $db_cmd
