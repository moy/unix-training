#! /bin/bash

exam_welcome () {
    echo "<p>Bonjour,</p>

<p>Ceci est une version de démonstration de l'examen de TP. Le
jour J, vous serez en salles de TP sur des machines fixes, et
les fichiers nécessaires au TP auront été installés pour vous
dans le répertoire \$HOME créé spécifiquement pour chaque machine et
chaque session d'examen. Pour cette version de démonstration, vous
devrez commencer par télécharger et extraire l'archive 
<a href=\"demo.tar.gz\">demo.tar.gz</a>. Toute référence à un fichier dans
les questions ci-dessous font référence aux fichiers de
l'archive. La question utilisant l'exécutable suspend ne marchera que
sur des machines Linux (ce qui inclut telesun).</p>

<p>Certaines questions ont été extraites directement du sujet d'examen final.</p>

<p>Entraînez-vous bien !</p>"
}

exam_mode=demo

all_questions () {
    # Juste pour s'entrainer ...
    sql_question 1 "La réponse à cette question est tout simplement 42." 42
    sql_question 1 "Quel est le nom (court) du serveur de référence en première année à l'Ensimag ?" telesun
    sql_question 1 "Quel est le nom du wiki à l'Ensimag (sans majuscules) ?" ensiwiki
    smart_question simple 1

    # Vraies questions (extraites de l'examen)
    smart_question text 2
    smart_question_dec size 2
    smart_question suspend 2
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

desc_question_suspend () {
    echo "La réponse est donnée par l'exécutable <tt>suspend</tt> dans le
répertoire <tt>suspend/</tt>. Lancez cet exécutable, suspendez-le au clavier,
puis relancez-le en tâche de fond pour avoir la réponse."
}

gen_question_suspend () {
    mkdir suspend
    cd suspend
    cp "$basedir"/suspend.c suspend.c
    reponse=$(echo "La reponse est $1 ." | perl -pe 's/./ord($&)." "/ge')
    perl -pi -e "s/REPONSE/$reponse/" suspend.c
    gcc suspend.c -o suspend
    rm -f suspend.c
}

EXAM_DIR=../gen-exam/
. "$EXAM_DIR"/exam-main.sh
