#! /bin/bash

# Simple demo of the exam, used as a step of the treasure hunt.

# This can serve as a demo of the exam environment if the students
# will have it, or just as a step of the hunt otherwise.

exam_welcome () {
    echo "<p>Bonjour,</p>

<p>Ceci est une version de démonstration de l'examen de TP (en version
générique, une version plus riche est disponible pour les étudiants
Ensimag).

L'examen lui-même est prévu pour se faire en salles de TP sur des
machines fixes. Pour cette version de démonstration, vous devrez
commencer par télécharger et extraire l'archive <a
href=\"demo.tar.gz\">demo.tar.gz</a>. Toute référence à un fichier
dans les questions ci-dessous font référence aux fichiers de
l'archive.</p>
"
}

exam_mode=demo
exam_lang=fr
exam_footer_include=etape-suivante.php

all_questions () {
    # Juste pour s'entrainer ...
    basic_question 1 "La réponse à cette question est tout simplement 42 (il n'y a pas de piège, c'est juste pour comprendre comment marche l'interface web)." 42
    smart_question simple 1

    # Vraies questions (extraites de l'examen)
    smart_question text 2
    smart_question_dec size 2
    smart_question gz 2

    # pour vérifier qu'on vient bien du jeu de piste ...
    basic_question 3 "La réponse à cette question vous a été donnée par l'étape précédente du jeu de piste (E11)" b3147554
}

desc_question_simple () {
    echo "La réponse à cette question est $(hash simple)."
}

gen_question_simple () {
    true # nothing to prepare here.
}

# Expansive things are prepared once and for all. This avoids re-doing
# the same for each students. Benchmarks show that this saves a
# few seconds per student, i.e. a few tens of minutes total.
# This may help in case we have to re-generate it live ...
prepare_questions () {
    true # nothing to prepare for such simple exam.
}

desc_question_text () {
    echo "La réponse à cette question se trouve dans le fichier <tt>$(hash fichiertexte).txt</tt>
dans votre répertoire de travail (c'est un fichier texte)."
}

gen_question_text () {
    echo "La réponse à la question est : $1" > $(hash fichiertexte).txt
}


desc_question_size () {
    echo "Quelle est la taille, en octets, du fichier $(hash sizefile) ? Entrer un nombre sans unité."
}

gen_question_size () {
    cat /dev/zero | head -c $1 > $(hash sizefile)
}

desc_question_gz () {
    echo "La réponse se trouve dans le fichier <tt>reponse.gz</tt>, un
    fichier texte qui a été compressé via gzip."
}

gen_question_gz () {
    echo "La réponse est $1 ." > reponse
    rm -f reponse.gz
    gzip reponse
}

EXAM_DIR=../gen-exam/
. "$EXAM_DIR"/exam-main.sh
