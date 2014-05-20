. "$EXAM_DIR"/exam-lib.sh
. "$EXAM_DIR"/exam-obfuscation-lib.sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--output DIR, -o DIR
			Output directory
	--cleanup	Remove output directory
	--cleanup-db	Remove existing lines for this subject in database
	--apply		Apply generated SQL direcly
	--subject N	Subject number
	--verbose	Be verbose
	--postgresql	Use PostgreSQL syntax
	--mysql		Use MySQL syntax
	--list list.csv	Use list.csv as student list file
	--tar		Compress (.tar.gz) generated files
EOF
}

tar=no
list_students=${exam_list_students:-list_students.csv}
outdir=exam_genere
outsql=
cleanup=no
clean_db=no
apply=no
# $exam_subject_number may be defined in the exam file.
subject=$exam_subject_number
basedir=$(pwd)
verbose=no
dbtype=${exam_dbtype:-mysql}
php_only=no

while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
	"--output"|"-o")
	    shift
	    outdir=$1
	    ;;
	"--cleanup")
	    cleanup=yes
	    ;;
	"--cleanup-db")
	    cleanup_db=yes
	    ;;
	"--apply")
	    apply=yes
	    ;;
	"--subject")
	    shift
	    subject=$1
	    ;;
	"--verbose")
	    verbose=yes
	    ;;
	"--postgresql")
	    dbtype=postgresql
	    ;;
	"--mysql")
	    dbtype=mysql
	    ;;
	"--demo")
	    die "--demo must be the first option, sorry"
	    ;;
	"--list")
	    shift
	    list_students="$1"
	    ;;
	"--php-only")
	    php_only=yes
	    ;;
	"--tar"|"--archive") # --tar is deprecated
	    archive=yes
	    ;;
	"--zip")
	    # Already dealt with in exam-main.sh
	    ;;
        *)
            echo "ERROR: Unrecognized option $1"
            usage
            exit 1
            ;;
    esac
    shift
done

if [ "$outsql" = "" ]; then
    outsql=$outdir/questions.sql
fi

if [ "$subject" = "" ]; then
    die "Please specify subject number with --subject N."
fi

if [ "$cleanup" = "yes" ]; then
    rm -fr "$outdir"
    rm -f "$outsql"
fi

mkdir -p "$outdir" || die "Cannot create directory $outdir"
list_students=$(absolute_path "$list_students")
outsql=$(absolute_path "$outsql")
EXAM_DIR=$(absolute_path "$EXAM_DIR")

cd "$outdir" || die "Cannot enter directory $outdir"
# make outdir absolute.
outdir=$(pwd)

exam_install_php
exam_config_php sql > "$outdir"/php/inc/config.php

if [ "$php_only" = "yes" ]; then
    echo "PHP files generated in:"
    echo
    echo "  $outdir"/php/
    echo
    echo "Skipping SQL generation (--php-only in use)"
    exit 0
fi

if [ -f "$outsql" ]; then
    die "$outsql already exists.
Remove it manually or use --cleanup."
fi

prepare_questions

case "$dbtype" in
    "postgresql")
	sql_raw "SET client_encoding = 'UTF8';"
	;;
    "mysql")
	sql_raw "SET NAMES 'UTF8';"
	;;
esac

if [ "$cleanup_db" = "yes" ]; then
    sql_raw "DELETE FROM exam_unix_subject_questions WHERE id_subject = '$subject';"
    sql_raw "DELETE FROM exam_unix_forms    WHERE id_subject = '$subject';"
    sql_raw "DELETE FROM exam_unix_question WHERE id_subject = '$subject';"
    sql_raw "DELETE FROM exam_unix_logins   WHERE id_subject = '$subject';"
    sql_raw "DELETE FROM exam_unix_subject  WHERE id         = '$subject';"
fi
sql_raw "INSERT INTO exam_unix_subject(id, descriptif) VALUES ('$subject', '$(sql_escape "$exam_subject_title")');"

sql_newline

coefficients=()

for login in $(get_logins); do
    question=1
    session=$(get_session "$login")
    machine=$(get_machine "$login")
    first_name=$(get_first_name "$login" | sql_escape_pipe)
    familly_name=$(get_familly_name "$login" | sql_escape_pipe)
    echo "login = $login; session = $session; machine = $machine; first_name = $first_name; familly_name = $familly_name"
    studentdir="$outdir/php/subjects/$session/$machine"
    mkdir -p "$studentdir"
    cd "$studentdir"

    sql_comment "Etudiant $login"
    sql_echo "Importing questions/answers for $first_name $familly_name ($login)"
    sql_raw "INSERT INTO exam_unix_logins
                    (id_subject,   session,    machine,    login, initial_login,    first_name, initial_first_name,    familly_name, initial_familly_name)
             VALUES ('$subject', '$session', '$machine', '$login',      '$login', '$first_name',      '$first_name', '$familly_name',      '$familly_name');"

    all_questions

    sql_newline
done

# Don't stay inside a student's directory (it will be tar-ed and
# deleted).
cd "$outdir"

sql_comment "Coefficients of questions"

sum=0
for (( i = 1 ; i <= ${#coefficients[@]} ; i++ )); do
    sql_coef $i ${coefficients[$i]}
    sum=$(($sum + ${coefficients[$i]}))
done

echo "Number of questions: ${#coefficients[@]}"
echo "Total coefficients: $sum"

if [ "$archive" = "yes" ]; then
    echo "Packing subject directory to sujet.tar.gz and sujet.zip ..."
    for login in $(get_logins); do
	session=$(get_session "$login")
	machine=$(get_machine "$login")
	(
	    cd "$outdir/$session/$machine" &&
	    tar czf ../"$machine"-sujet.tar.gz . &&
	    zip -r ../"$machine"-sujet.zip . &&
	    cd .. &&
	    rm -fr "$machine" &&
	    mkdir "$machine" &&
	    mv "$machine"-sujet.tar.gz "$machine"/sujet.tar.gz &&
	    mv "$machine"-sujet.zip "$machine"/sujet.zip
	)
    done
fi

# A few useful SQL and shell scripts generated in the target dir.
"$EXAM_DIR"/init-db.sh > "$outdir"/init-db.sql
"$EXAM_DIR"/init-db.sh --drop-tables > "$outdir"/init-db-drop-tables.sql

case "$dbtype" in
    "postgresql")
	cat > "$outdir"/hard-reset-db.sh <<EOF
#! /bin/sh

# WARNING: untested code!

cat ./init-db-drop-tables.sql ./questions.sql | \\
    psql -h "$exam_dbhost" -d "$exam_dbname" -U "$exam_dbuser"
EOF
	chmod +x "$outdir"/hard-reset-db.sh
	;;
    "mysql")
	cat > "$outdir"/hard-reset-db.sh <<EOF
#! /bin/sh

cat ./init-db-drop-tables.sql ./questions.sql | \\
    mysql --user="$exam_dbuser" -h "$exam_dbhost" -p --database="$exam_dbname"
EOF
	chmod +x "$outdir"/hard-reset-db.sh
	;;
    *)
	echo "Unknown database type $dbtype"
	;;
esac


if [ "$apply" = "yes" ]; then
    # needs a password.
    case "$dbtype" in
	"postgresql")
	    psql -h "$exam_dbhost" -d "$exam_dbname" -U "$exam_dbuser" -f "$outsql"
	    ;;
	"mysql")
	    mysql -h "$exam_dbhost" -p --user="$exam_dbuser" --database="$exam_dbname" < "$outsql"
	    ;;
	*)
	    echo "Unknown database type $dbtype"
	    ;;
    esac
fi

for d in "$outdir/php/subjects/"*/
do
    ln -s "$d" session-"$(basename "$d")"
done

echo
echo "Generated files in $outdir"
echo "- ${outsql#$outdir/}"
echo "- init-db.sql and init-db-drop-tables.sql to initialize and"
echo "  reset the DB (use with care)".
echo "- php/subjects/{1,2}/ : files to put on students account for sessions 1 and 2"
echo "  (there are symlinks at the toplevel to help you find these)"
echo "- php/ : PHP files to put on the server. php/inc/config.php is the configuration file."
