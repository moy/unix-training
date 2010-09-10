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

# Database to use (mysql/postgresql)
exam_dbtype=mysql

# Subject number. This allows you to store several exams in the same
# tables in the database, each subject being identified by a
# number. If you don't have multiple exams, just leave 1.
exam_subject_number=1

# Short description of the exam. It is stored in the database, and
# displayed on top of the web page.
exam_subject_title="Example exam"

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
    sql_question 2 "The answer for $login, on $machine, in session $session for exam number $subject is $(hash reponse)" $(hash reponse)
    sql_question 1 "Another answer to another question: $(hash autrereponse)" $(hash autrereponse)

    # You don't have to make the answer different for everybody, it's just a possibility.
    sql_question 1 "This is a <em>simple</em> question, whose anser is basically 42." 42
}

# Functions called by smart_question simple above.
desc_question_simple () {
    echo "The answer for $login, on machine $machine, in session $session for the exam $subject is $(hash simple)"
}

gen_question_simple () {
    true # nothing to prepare here.
}

# Exam files must finish like this: defining EXAM_DIR, and sourcing
# exam-main.sh in this directory.
EXAM_DIR=../gen-exam/
. "$EXAM_DIR"/exam-main.sh
