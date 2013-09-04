#! /bin/sh

if [ -r ./db-setup.sh ]; then
    . ./db-setup.sh
fi
dbtype=${exam_dbtype:-mysql}

db_cmd=cat

if [ "$apply" = "yes" ]; then
    case "$exam_dbtype" in
	"mysql")
	    db_cmd="mysql -h $exam_dbhost -p --database=$exam_dbname"
	    ;;
	*)
	    echo "dbtype $exam_dbtype not managed with --apply, sorry"
	    exit 1
	    ;;
    esac
fi

echo "$db_cmd"
