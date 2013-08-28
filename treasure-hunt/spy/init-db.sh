#! /bin/sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--postgresql	Use PostgreSQL syntax.
	--drop-tables	Generate "DROP TABLE" statements to cleanup the database.
	--apply		Apply SQL directly to the database

Typical usage:

./init-db.sh --drop-tables | mysql -h <host> -p --database=<dbname>

./init-db.sh --apply

EOF
}

drop=no
apply=no
exam_dbtype=
php=no

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
	"--php")
	    php=yes
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

start_query=
end_query=""

if [ "$php" = yes ]; then
    cat <<\EOF
<?php
define('_VALID_INCLUDE', TRUE);
include_once './inc/common.php';
include_once './inc/authentication.php';
exam_connect_maybe();
EOF
    start_query="exam_query('";
    end_query="');"
fi

drops=""
creates=""

create_table() {
    # drop tables in reverse order, otherwise it breaks foreign key.
    if [ "$drop" = "yes" ]; then
	drops="$start_query
DROP TABLE IF EXISTS $1;
$end_query
$drops"
    fi
    creates="$creates
$start_query
CREATE TABLE $1 (
$(cat)
)${engine};
$end_query
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

if [ "$php" = yes ]; then
    cat <<\EOF
?>
done.
EOF
fi
