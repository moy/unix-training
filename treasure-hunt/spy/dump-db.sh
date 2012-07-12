#! /bin/sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.

Typical usage:

./dump-db.sh > dump.sql

EOF
}

exam_dbtype=

while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
        "--postgresql")
	    exam_dbtype=postgresql
            ;;
        *)
            echo "unrecognized option $1"
            usage
            exit 1
            ;;
    esac
    shift
done

. ./db-setup.sh

printf '%s\n' "-- mysqldump -h $exam_dbhost -u $exam_dbuser -p moy hunt_student hunt_access"
printf '%s\n' "-- triggered by $0 on $(hostname --long)"
printf '%s\n' "--"
mysqldump -h "$exam_dbhost" -u "$exam_dbuser" -p moy hunt_student hunt_access
