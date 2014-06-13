#! /bin/bash

# This is an example of exam file.

# Comments here should help you to understand the principle, and to
# build your own exam, with actual questions.

# An exam file starts with some definitions like this:

# Name of the database
exam_dbname=moy

# Database user
exam_dbuser=moy

# Host where the database is located
exam_dbhost=arpont.imag.fr

# Database password (will be prompted interactively if not specified)
exam_dbpass=insertdbpasswordhere

# Database to use (mysql/postgresql)
exam_dbtype=mysql

# Subject number. This allows you to store several exams in the same
# tables in the database, each subject being identified by a
# number. If you don't have multiple exams, just leave 1.
exam_subject_number=1

# Short description of the exam. It is stored in the database, and
# displayed on top of the web page.
exam_subject_title="Example exam"

# (optional) key used for generating hash-based answers.
# The pseudo-random anwser generation uses this variable. One needs
# this string to be able to guess the answers, hence, even if the
# source code of the exam (except this key) is public, no one can
# guess the answers.
exam_hash_key="xbCZ;9101"

# Name of the file holding the students list. It must be a CSV file
# (comma-separated value) containing the following columns:
# login;first_name;last_name;session_number;machine
# (not needed in demo mode)
exam_list_students=list_test.csv

# Set to some non-empty value to hide points in the web interface.
exam_hide_points=

# Welcome message, displayed below the title in the web page. You can
# use HTML formatting if you want (but it is your responsibility
# to write valid HTML here).
exam_welcome () {
    echo "<p>This is a test <strong>exam</strong>.</p>";
}

# List of questions. This is a shell function, each line corresponding to a function.
all_questions () {
    # Dumb questions, for testing.
    
    # High-level way to define a question: smart_question
    #
    # Argument 1 is the name of the question, argument 2 is the coefficient.
    # This will call desc_question_<name> and gen_question_<name> (see
    # below and the document of smart_question in the code).
    smart_question simple 1
    
    # Low-level way to define a question. Here, we explicitely chose the question and the answer.
    basic_question 2 "The answer for $login, on $machine, in session $session for exam number $subject is $(hash reponse)" $(hash reponse)
    basic_question 1 "Another answer to another question: $(hash autrereponse)" $(hash autrereponse)

    # You don't have to make the answer different for everybody, it's just a possibility.
    basic_question 1 "This is a <em>simple</em> question, whose anser is basically 42." 42

    smart_question_comp mcq 1
}

# Expansive things are prepared once and for all. This avoids re-doing
# the same for each students. Benchmarks show that this saves a
# few seconds per student, i.e. a few tens of minutes total.
# This may help in case we have to re-generate it live ...
#
# prepare_questions () {
#     : do something once (not once for each student)
# }

# Functions called by smart_question simple above.
desc_question_simple () {
    echo "The answer for $login, on machine $machine, in session $session for the exam $subject is $(hash simple)"
}

gen_question_simple () {
    true # nothing to prepare here.
}


desc_question_mcq () {
    echo "Pick the right answer."
}

answer_question_mcq () {
    echo "42"
}

form_question_mcq () {
    form_option '41' 'Not this one'
    form_option '42' 'This one'
    form_option '43' 'Not this one either'
}



# Exam files must finish like this: defining EXAM_DIR, and sourcing
# exam-main.sh in this directory.
EXAM_DIR=../gen-exam/
. "$EXAM_DIR"/exam-main.sh

# Read ../gen-exam/exam-lib.sh and the comments it contains for more
# details about the user API.
