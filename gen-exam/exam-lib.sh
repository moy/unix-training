source_dir=$(pwd)

#
# User API: smart_question, smart_question_dec, and basic_question
# Simplest way to define a question.
#
# $1 = short name for the question.
# $2 = number of points (coefficient).
#
# This will call:
#
# - desc_question_$1 to get the question (the question displayed
#   to the user will be the standard output of the function),
#
# - gen_question_$1 to generate required files. The expected answer is
#   passed as first argument of gen_question_$1 (it is computed as
#   $(hash "$1")).
smart_question () {
    if [ "$verbose" = "yes" ]; then
	echo "smart_question $@"
	time=time
    else
	time=""
    fi
    cd "$studentdir"
    eval $time gen_question_"$1" $(hash "$1") || die "Please check your question definitions"
    basic_question "$2" "$(desc_question_"$1")" $(hash "$1") || die "Please check your question definitions"
}

# Decimal variant of smart_question (used when the answer has to be
# decimal, and sufficiently small).
#
# $1, $2 = same as smart_question
smart_question_dec () {
    if [ "$verbose" = "yes" ]; then
	echo "smart_question_dec $@"
	time=time
    else
	time=""
    fi
    cd "$studentdir"
    eval $time gen_question_"$1" $(dechash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(dechash "$1")
}

# Decimal variant of smart_question (used when the answer has to be
# sufficiently small, e.g. when the answer cannot be copy-pasted and
# has to be re-typed by the student).
#
# $1, $2 = same as smart_question
smart_question_short () {
    if [ "$verbose" = "yes" ]; then
	echo "smart_question_short $@"
	time=time
    else
	time=""
    fi
    cd "$studentdir"
    eval $time gen_question_"$1" $(shorthash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(shorthash "$1")
}

# Constant variant of smart_question (used when the answer does not
# depend on the student). The expected answer is $(consthash "$1").
# Like smart_question, this will call gen_question_$1 and
# desc_question_$1. It is recommended that you do nothing in
# gen_question_$1, but instead use prepare_question to generate the
# material for the question only once (otherwise, the code will be
# executed for each question).
#
# $1, $2 = same as smart_question
smart_question_const () {
    if [ "$verbose" = "yes" ]; then
	echo "smart_question_const $@"
	time=time
    else
	time=""
    fi
    cd "$studentdir"
    eval $time gen_question_"$1" $(consthash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(consthash "$1")
}

# Inserts a question in the database. This is a low-level function,
# you probably want to use smart_question and smart_question_* above
# instead.
#
# $1 = coefficient
# $2 = question
# $3 = expected answer
basic_question () {
    coefficients["$question"]="$1"
    printf "INSERT INTO exam_unix_question
       (id, id_subject, machine, session, question_text, correct_answer, student_answer)
VALUES ('%s',     '%s',    '%s',    '%s',          '%s',           '%s',           NULL);\n" \
       "$question" "$subject" "$machine" "$session" "$(sql_escape "$2")" "$(sql_escape "$3")" >> "$outsql"
    question=$((question + 1))
}

# End of user API.

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

# hash "any string": makes a hash of $1, the student login, and
# some other arbitrary string.
hash () {
    echo "$login $1 $exam_hash_key" | sha1sum | head -c 8
}

consthash () {
    echo "$1 $exam_hash_key" | sha1sum | head -c 8
}

# array of arbitrary hashes. It's quicker to access an array than to
# actually compute the hash each time.
for i in $(seq 100); do
    hashes[$i]=$(hash $i)
done

dechash () {
    # A non-nul number in decimal form.
    # xargs expr 1 + ensures non-zero, and remove leading zeros.
    hash "$1" | tr '[a-f]' '[1-6]' | head -c 4 | xargs expr 1 +
}

# dechash_bound string howmuch
# generate a pseudo-random number between howmuch and 2*howmuch
dechash_bound () {
    hash_val=$(dechash $1)
    hash_mod=$(($hash_val % $2))
    echo $(($hash_mod + $2))
}

shorthash () {
    hash "$@" | head -c 4
}

sql_escape_pipe () {
    sed -e "s/'/''/g" -e 's/\\/\\\\/g'
}

sql_escape () {
    printf "%s" "$1" | sql_escape_pipe
}

# Meant to be used in double quotes => does not escape '.
php_escape_pipe () {
    sed -e 's/\\/\\\\/g' -e 's/"/\\"/g'
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
if [ "$exam_footer_include" != "" ]; then
    echo "\$exam_footer_include = \"$exam_footer_include\";"
else
    # make sure the variable is defined anyway, to prevent users from
    # setting it with GET parameters.
    echo "\$exam_footer_include = NULL;"
fi
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
