#! /bin/sh


usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help		This help message.
	--postgresql	Use PostgreSQL syntax.
	--drop-tables	Generate "DROP TABLE" statements to cleanup the database.

Typical usage:

./init-db.sh --drop-tables | mysql -h people-verimag.imag.fr -p --database=moy

EOF
}

dbtype=mysql
drop=no
apply=no

while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
        "--postgresql")
	    dbtype=postgresql
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

if [ "$dbtype" = "mysql" ]; then
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

create_table exam_unix_subject <<\EOF
    id integer NOT NULL PRIMARY KEY,
    descriptif text NOT NULL
EOF

create_table exam_unix_logins <<\EOF
    id_subject integer NOT NULL,
    session integer NOT NULL,
    machine varchar(255) NOT NULL,
    login varchar(255) NOT NULL,
    initial_login varchar(8) NOT NULL,
    first_name text NOT NULL,
    initial_first_name text NOT NULL,
    familly_name text NOT NULL,
    initial_familly_name text NOT NULL,
    student_id varchar(255) NOT NULL,
    initial_student_id varchar(255) NOT NULL,
    PRIMARY KEY (id_subject, session, machine),
    FOREIGN KEY (id_subject) REFERENCES exam_unix_subject(id)
EOF

create_table exam_unix_forms <<\EOF
    id integer NOT NULL, -- Question number, not unique (one instance per student)
    id_subject integer,
    FOREIGN KEY (id_subject) REFERENCES exam_unix_subject(id),
    machine varchar(256) NOT NULL,
    session integer,
    name text,
    value text
EOF

create_table exam_unix_question <<\EOF
    id integer NOT NULL, -- Question number, not unique (one instance per student)
    id_subject integer,
    FOREIGN KEY (id_subject) REFERENCES exam_unix_subject(id),
    machine varchar(256) NOT NULL,
    session integer,
    question_text text NOT NULL,
    correct_answer text NOT NULL,
    student_answer text
EOF

create_table exam_unix_subject_questions <<\EOF
    id_subject integer,
    id_question integer, -- Not strictly speaking a foreign key:
                         -- Reference the question number, which isn't unique.
    coeff integer,
    FOREIGN KEY (id_subject) REFERENCES exam_unix_subject(id)
EOF

if [ "$dbtype" = "postgresql" ]; then
    echo "SET search_path=public;
"
fi

if [ "$apply" = "yes" ]; then
    case "$dbtype" in
	"mysql")
	    printf "%s%s" "$drops" "$creates" | mysql -h people-verimag.imag.fr -p --database=moy
	    ;;
	*)
	    echo "dbtype $dbtype not managed with --apply, sorry"
	    exit 1
	    ;;
    esac
else
    printf "%s%s" "$drops" "$creates"
fi
