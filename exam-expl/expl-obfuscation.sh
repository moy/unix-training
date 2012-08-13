#! /bin/bash

exam_welcome () {
    echo "<p>Hello,</p>

<p>This is a demo preview of the exam system. First, you'll have to
download <a href=\"demo.tar.gz\">demo.tar.gz</a>. Any reference to a
file refers to a file in this archive.</p>"
}

exam_mode=demo

all_questions () {
    # Just a warm-up.
    basic_question 1 "The answer is 42." 42

    # Real questions
    smart_question text 2
    smart_question_dec size 2
    smart_question suspend 2
    smart_question ada 3
    smart_question latex 2
}

# Expansive things are prepared once and for all. This avoids re-doing
# the same for each students. Benchmarks show that this can save a
# few seconds per student, i.e. a few tens of minutes total.
# This may help in case we have to re-generate it live ...
prepare_questions () {
    true # nothing to prepare for such simple exam.
}

desc_question_text () {
    echo "The answer for this question is in the file <tt>$(hash fichiertexte).txt</tt> (this is a text file)."
}

gen_question_text () {
    # $1 is the answer, we write it in an arbitrary file. $(hash ...)
    # is deterministic, so calling it twice here and in
    # desc_question_text yields the same result.
    echo "The answer is: $1" > $(hash fichiertexte).txt
}

desc_question_latex () {
    echo "The answer is in the file <tt>latex.tex</tt>.
The source code is unreadable, but the compiled version is."
}

gen_question_latex () {
    # We use ../gen-exam/exam-obfuscation-lib.sh for LaTeX
    (
	echo '\documentclass[a4paper]{article}
\usepackage[utf8]{inputenc}'
	latextable
	echo '\begin{document}'
	echo "The answer is : $1 ." | latexencode
	echo '\end{document}'
	) > latex.tex
}

desc_question_ada () {
    echo "The answer is in the file <tt>ada.adb</tt>."
    echo "The source code is unreadable, but the compiled version
provides a readable output when executed. You'll probably have
to rename the file to be able to compile it."
}

gen_question_ada () {
    # We use ../gen-exam/exam-obfuscation-lib.sh for Ada
    (
	echo "-- This program must be in a file question_ada.adb
-- Compile and execute it to continue.

"
	adawithuse
	
	echo "procedure question_ada is"
	adadecode
	echo "begin"
	Put_Line "Hello,"
	New_Line
	Noise
	Put_Line "The answer for this question is $1 ."
	Noise
	echo "end question_ada;"
    ) > ada.adb
}

desc_question_suspend () {
    echo "The answer is given by the executable <tt>suspend</tt> in the directory <tt>suspend/</tt>. Launch this executable, suspend it with the keyboard, and re-launch it in background to get the answer."
}

gen_question_suspend () {
    mkdir suspend
    cd suspend
    cp "$basedir"/suspend.c suspend.c
    reponse=$(echo "The answer is $1 ." | perl -pe 's/./ord($&)." "/ge')
    perl -pi -e "s/ANSWER/$reponse/" suspend.c
    gcc suspend.c -o suspend
    rm -f suspend.c
}

desc_question_size () {
    echo "What is the size, in bytes, of the file $(hash sizefile)? Give a number without unit."
}

gen_question_size () {
    # create a file of size $1
    cat /dev/zero | head -c "$1" > $(hash sizefile)
}

EXAM_DIR=../gen-exam/
. "$EXAM_DIR"/exam-main.sh
