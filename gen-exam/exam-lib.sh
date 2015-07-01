source_dir=$(pwd)

. "$EXAM_DIR"/exam-api.sh

# Calls gen_question_$1 $2 if the function exists.
gen_question_maybe () {
    if [ "$verbose" = "yes" ]; then
	echo "smart_question_const $@"
	time=time
    else
	time=""
    fi
    if [ "$(command -v gen_question_"$1")" = gen_question_"$1" ]; then
	cd "$studentdir"
	eval $time gen_question_"$1" "$2" || die "Failed to call gen_question_$1."
    else
	debug "No gen_question_$1 function => not calling it"
    fi
}

if [ "$(command -v all_questions)" != all_questions ]; then
    echo "ERROR: function all_questions is not defined."
    echo "You should create an exam file defining this function and"
    echo "ending with:"
    echo
    echo "EXAM_DIR=where/gen-exam/is/"
    echo ". \"\$EXAM_DIR\"/exam-main.sh"
    echo
    exit 1
fi

if [ "$(command -v prepare_questions)" != prepare_questions ]; then
    prepare_questions () {
	echo "You did not define a function prepare_questions. Not preparing anything."
    }
fi

if [ "$(command -v exam_welcome)" != exam_welcome ]; then
    exam_welcome () {
	# default welcome message
	echo 'Welcome to the exam'
    }
fi

if [ "$(command -v exam_extra_config)" != exam_extra_config ]; then
    exam_extra_config () {
	echo "// define exam_extra_config() in your subject script to add"
	echo "// configuration directives here."
    }
fi

debug () {
    if [ "$verbose" = "yes" ]; then
	printf "%s\n" "$*"
    fi
}

die () {
    echo "FATAL ERROR: $@"
    exit 1
}

absolute_path () {
    printf "%s/%s" "$(cd "$(dirname "$1")"; pwd)" "$(basename "$1")"
}

# CSV parsing functions.
get_logins () {
    cut -d \; -f 1 < "$list_students"
}

get_first_name () {
    grep "^$1;" "$list_students" | cut -d \; -f 2
}

get_familly_name () {
    grep "^$1;" "$list_students" | cut -d \; -f 3
}
    
get_session () {
    grep "^$1;" "$list_students" | cut -d \; -f 4
}

get_machine () {
    grep "^$1;" "$list_students" | cut -d \; -f 5
}

get_student_id () {
    grep "^$1;" "$list_students" | cut -d \; -f 6
}

sql_escape_pipe () {
    sed -e "s/'/''/g" -e 's/\\/\\\\/g'
}

sql_escape () {
    printf "%s" "$1" | sql_escape_pipe
}

# Meant to be used in double quotes => does not escape '.
php_escape_pipe () {
    sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\$/\\$/g'
}

php_escape () {
    printf "%s" "$1" | php_escape_pipe
}

sql_newline () {
    echo >> "$outsql"
}

sql_comment () {
    echo "$@" | sed 's/^/-- /' >> "$outsql"
}

sql_echo () {
    case "$dbtype" in
	"mysql")
	    echo "SELECT '$(sql_escape "$1")' as ' ';" >> "$outsql"
	    ;;
	"postgresql")
	    echo "\\echo '$(sql_escape "$1")'" >> "$outsql"
	    ;;
	*)
	    # Do nothing
	    ;;
    esac
}

sql_raw () {
    echo "$@" >> "$outsql"
}

# Inserts the coefficient associated to a question number in the
# database.
# 
# $1 = question number
# $2 = coefficient
sql_coef () {
    printf "INSERT INTO exam_unix_subject_questions
       (id_subject, id_question, coeff)
VALUES ('%s',       '%s',        '%s');\n" \
    "$subject" "$1" "$2" >> "$outsql"
}

exam_read_dbpass () {
    if [ "$exam_dbpass" = "" ]; then
	printf "%s" "Please, enter database password (to be inserted into config.php): " >&2
	stty -echo
	read passwd
	stty echo
	printf "%s" "$passwd"
	echo >&2
    else
	echo "$exam_dbpass"
    fi
}

# Generate custom config.php file.
exam_config_php () {
    echo "<?php"
    echo "defined('_VALID_INCLUDE') or die('Direct access not allowed.');"
    if [ "$1" = "sql" ]; then
	echo "\$subject = ${subject:-1};"
	echo "\$session = 1; // To be changed manually between sessions"
	echo "\$dbname = '$exam_dbname';"
	echo "\$dbuser = '$exam_dbuser';"
	echo "\$dbhost = '$exam_dbhost';"
	echo "\$dbpass = '$(exam_read_dbpass)';"
	echo "\$dbtype = '$dbtype';"
    else
	echo "\$session = 'demo';"
        echo "\$exam_php_session = '$(uuid)';"
    fi
    echo "
\$exam_auth    = 'http'; // change to 'https' or 'none' if needed.
\$exam_webuser = '${exam_webuser:-user}'; // used to access /private/
\$exam_webpass = '${exam_webpass:-$(uuid)}';
\$mode = '$1'; // 'sql' or 'demo'
\$lang = '$exam_lang'; // 'en' or 'fr'

\$welcome_msg = \"$(exam_welcome | php_escape_pipe)\";
"
    if [ "$preferred_archive" = zip ]; then
	echo "
\$subject_basename = 'sujet.zip';
\$subject_mimetype = 'application/zip';
"
    fi

    if [ "$exam_hide_points" != "" ]; then
	echo "\$exam_hide_points = true;"
    else
	echo "\$exam_hide_points = false;"
    fi

    if [ "$exam_footer_include" != "" ]; then
	echo "\$exam_footer_include = \"$exam_footer_include\";"
    else
	# make sure the variable is defined anyway, to prevent users from
	# setting it with GET parameters.
	echo "\$exam_footer_include = NULL;"
    fi
    
    echo
    exam_extra_config
    echo
    
    echo "?>"
}

exam_install_php () {
    (cd "$EXAM_DIR"; git ls-files php | tar cf - -T -) | \
	(cd "$outdir"; tar xf -)
    if [ "$exam_footer_include" != "" ]; then
	if [ ! -r "$source_dir/$exam_footer_include" ]; then
	    die "$source_dir/$exam_footer_include does not exist"
	fi
	mkdir -p "$outdir/php/inc/"
	cp "$source_dir/$exam_footer_include" "$outdir/php/inc/$exam_footer_include"
    fi
}
