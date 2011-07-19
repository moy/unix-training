#! /bin/sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--postgresql	Use PostgreSQL syntax.
	--drop-tables	Generate "DROP TABLE" statements to cleanup the database.

Typical usage:

./init-db.sh --drop-tables | mysql -h arpont.imag.fr -p --database=moy

EOF
}

drop=no
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
	"--drop-tables")
	    drop=yes
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

if [ "$exam_dbtype" = "mysql" ]; then
    engine=" ENGINE=InnoDB"
else
    engine=""
fi

drops=""
creates=""

create_table() {
    # drop tables in reverse order, otherwise it breaks foreign key.
    if [ "$drop" = "yes" ]; then
	drops="DROP TABLE IF EXISTS $1;
$drops"
    fi
    creates="$creates
CREATE TABLE $1 (
$(cat)
)${engine};
"
}

create_table hunt_student <<\EOF
    login varchar(8) NOT NULL PRIMARY KEY,
    `group` varchar(10) NOT NULL,
    first_name text NOT NULL,
    familly_name text NOT NULL
EOF

create_table hunt_access <<\EOF
    login varchar(8) NOT NULL,
    step varchar(10) NOT NULL,
    date DATETIME NOT NULL
EOF

(
if [ "$exam_dbtype" = "postgresql" ]; then
    echo "SET search_path=public;
"
fi

printf "%s%s" "$drops" "$creates"
) | $db_cmd
