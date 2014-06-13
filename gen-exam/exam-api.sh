# User API.

## Questions definitions: smart_question, smart_question_dec, and
## basic_question Simplest way to define a question.

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
    debug smart_question "$@"
    gen_question_maybe "$1" $(hash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(hash "$1") "$1" || die "Please check your question definitions"
}

# Decimal variant of smart_question (used when the answer has to be
# decimal, and sufficiently small).
#
# $1, $2 = same as smart_question
smart_question_dec () {
    debug smart_question_dec "$@"
    gen_question_maybe "$1" $(dechash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(dechash "$1") "$1"
}

# Decimal variant of smart_question (used when the answer has to be
# sufficiently small, e.g. when the answer cannot be copy-pasted and
# has to be re-typed by the student).
#
# $1, $2 = same as smart_question
smart_question_short () {
    debug smart_question_short "$@"
    gen_question_maybe "$1" $(shorthash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(shorthash "$1") "$1"
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
    debug smart_question_const "$@"
    gen_question_maybe "$1" $(consthash "$1")
    basic_question "$2" "$(desc_question_"$1")" $(consthash "$1") "$1"
}

# Question whose answer must be computed by a piece of code.
#
# For smart_question and its variants, the answer is known for each
# student, and the shell functions associated to the question set up
# an environment that allow the student to find it.
#
# Here, the answer itself is computed by a shell function: in addition
# to gen_question_$1 and desc_question_$1, a new function
# answer_question_$1 is called to do this. The function takes no
# argument, but can use $(hash ...) and its variants. It must produce
# the answer on its standard output.
#
# $1, $2 = same as smart_question
smart_question_comp () {
    debug smart_question_const "$@"
    gen_question_maybe "$1" ''
    answer=$(answer_question_"$1") || die "Failed to compute answer for question $1"
    if [ "$answer" = "" ]; then
	die "Answer for question $1 is empty"
    fi
    basic_question "$2" "$(desc_question_"$1")" "$answer" "$1"
}


# Inserts a question in the database. This is a low-level function,
# you probably want to use smart_question and smart_question_* above
# instead.
#
# $1 = coefficient
# $2 = question
# $3 = expected answer
# $4 = question short name
basic_question () {
    coefficients["$question"]="$1"
    printf "INSERT INTO exam_unix_question
       (id, id_subject, machine, session, question_text, correct_answer, student_answer)
VALUES ('%s',     '%s',    '%s',    '%s',          '%s',           '%s',           NULL);\n" \
       "$question" "$subject" "$machine" "$session" "$(sql_escape "$2")" "$(sql_escape "$3")" >> "$outsql"
    if [ "$(command -v form_question_"$4")" = form_question_"$4" ]; then
	form_text=""
	form_question_"$4"
    else
	form_text=""
    fi
    printf '%s\n' "$form_text" >> "$outsql"
    question=$((question + 1))
}

##
## Multiple-choice questions: use "smart_question_comp foo $coef" in
## all_questions to register the question, and implement e.g.
##
## answer_question_foo () {
##     echo "x" # value of the correct answer.
## }
##
## form_question_foo () {
##     form_option 'x' 'Some incorrect answer'
##     form_option 'y' 'The correct answer'
##     form_option 'z' 'Another incorrect answer'
## }
##
form_option () {
    form_text="$form_text
  INSERT INTO exam_unix_forms
         (id, id_subject, machine, session, name, value)
  VALUES ('$question', '$subject', '$machine', '$session', '$(sql_escape "$1")', '$(sql_escape "$2")');" >> "$outsql"
}

##
## Pseudo-random number generations : hash, consthash, dechash, dechash_bound
##

# hash "any string": makes a hash of $1, the student login, and
# some other arbitrary string.
hash () {
    echo "$login $1 $exam_hash_key" | sha1sum | head -c 8
}

# Constant (does not vary from student to student) pseudo-random
consthash () {
    echo "$1 $exam_hash_key" | sha1sum | head -c 8
}

# Decimal pseudo-random
dechash () {
    # A non-nul number in decimal form.
    # xargs expr 1 + ensures non-zero, and remove leading zeros.
    hash "$1" | tr '[a-f]' '[1-6]' | head -c 4 | xargs expr 1 +
}

# Short hash (4 characters)
shorthash () {
    hash "$@" | head -c 4
}

# array of arbitrary hashes. It's quicker to access an array than to
# actually compute the hash each time.
for i in $(seq 100); do
    hashes[$i]=$(hash $i)
done
for i in $(seq 1000); do
    dechashes[$i]=$(dechash $i)
done

# dechash_bound string howmuch
# generate a pseudo-random number between howmuch and 2*howmuch
dechash_bound () {
    hash_val=$(dechash $1)
    hash_mod=$(($hash_val % $2))
    echo $(($hash_mod + $2))
}


##
## Decimal/binary/hexadecimal translations
## 

# Decimal to binary conversion.
# Example: dec_to_bin 9 -> 1001
dec_to_bin() {
    python -c "from __future__ import print_function
print('{0:#b}'.format($1).replace('0b', ''))"
}

# Binary to decimal conversion.
# Example: dec_to_bin 1001 -> 9
bin_to_dec() {
    python -c "from __future__ import print_function
print(int('$1', 2))"
}

# Hexadecimal to binary conversion.
# Example: hex_to_bin A -> 1010
hex_to_bin() {
    python -c "from __future__ import print_function
print('{0:#b}'.format(0x$1).replace('0b', ''))"
}

# Binary pseudo-random hash on N bits.
# $1 = string to hash (same as hash's $1)
# $2 = max number of bits in the output (real output may be shorter,
#      since leading 0 are removed after counting bits)
binhash_numbits () {
    hex_to_bin $(hash "$1") | head -c "$2" | sed 's/^0*//'
}
