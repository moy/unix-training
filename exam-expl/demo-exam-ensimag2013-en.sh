#! /bin/bash

# English translation of the demo shown to Ensimag students in 2012
# (see demo-ensimag2012.sh for the French version).

exam_footer_include=next-step.php

exam_welcome () {
    echo "<p>Hello,</p>

<p>This is a demo of the lab-work exam. The D-Day, you will be working
in computer rooms and the files needed for the exam will have been
installed for you in a \$HOME directory created especially for each
machine, and each exam session.

For this version, you'll have to download and extract the following
tar archive first: <a href=\"demo.tar.gz\">demo.tar.gz</a>. Any
reference to a file in the questions below is a reference to a file in
this archive.</p>

<p>Some questions are taken directly from the final exam.</p>

<p>Enjoy it !</p>"
}

exam_mode=demo
exam_lang=en

all_questions () {
    # Just to train ...
    basic_question 1 "The answer for this question is basically 42." 42
    basic_question 1 "The answer for this one is 43." 43
    basic_question 1 "What is the name of the wiki in the Ensimag (without capitalization)?" ensiwiki
    smart_question simple 1

    # Actual questions (taken from the exam)
    smart_question text 2
    smart_question_dec size 2
    smart_question gz 2

    # To check that we do come from the previous step of the hunt.
    basic_question 3 "The answer has been given to you by the previous step of the treasure hunt (E11)." b3147554
}

desc_question_simple () {
    echo "The answer for this question is $(hash simple)."
}

gen_question_simple () {
    true # nothing to prepare here.
}

# Expansive things are prepared once and for all.
prepare_questions () {
    true # nothing to prepare for such simple exam.
}

desc_question_text () {
    echo "The answer for this question is located in the file <tt>$(hash fichiertexte).txt</tt>
in your working directory (this is a text file)."
}

gen_question_text () {
    echo "The answer is : $1" > $(hash fichiertexte).txt
}


desc_question_size () {
    echo "What is the size, in bytes, of the file $(hash sizefile)? Give a number without unit."
}

gen_question_size () {
    cat /dev/zero | head -c $1 > $(hash sizefile)
}

desc_question_gz () {
    echo "The answer is in the file <tt>answer.gz</tt>,
a text file compressed with gzip."
}

gen_question_gz () {
    echo "The answer is $1 ." > answer
    rm -f answer.gz
    gzip answer
}

EXAM_DIR=../gen-exam/
. "$EXAM_DIR"/exam-main.sh
