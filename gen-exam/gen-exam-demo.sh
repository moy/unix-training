. "$EXAM_DIR"/exam-lib.sh
. "$EXAM_DIR"/exam-obfuscation-lib.sh

usage () {
            cat << EOF
Usage: $(basename $0) [options]
Options:
	--help	This help message.
EOF
}

outdir=exam_genere
outphp=
cleanup=no
basedir=$(pwd)
verbose=no

while test $# -ne 0; do
    case "$1" in
        "--help"|"-h")
            usage
            exit 0
            ;;
	"--output"|"-o")
	    shift
	    outdir=$1
	    ;;
	"--cleanup")
	    cleanup=yes
	    ;;
	"--verbose")
	    verbose=yes
	    ;;
        *)
            echo "unrecognized option $1"
            usage
            exit 1
            ;;
    esac
    shift
done

if [ "$cleanup" = "yes" ]; then
    rm -fr "$outdir"
    rm -f "$outphp"
fi

if [ -f "$outphp" ]; then
    die "$outphp already exists.
Remove it manually or use --cleanup."
fi

if [ "$outphp" = "" ]; then
    outphp=$outdir/php/inc/demo-questions.php
fi

mkdir -p "$outdir" || die "Cannot create directory $outdir"
mkdir -p "$(dirname "$outphp")" || die "Cannote create base directory for $outphp"

# make $outphp absolute
outphp=$(absolute_path "$outphp")
EXAM_DIR=$(absolute_path "$EXAM_DIR")

cd "$outdir"
# make outdir absolute.
outdir=$(pwd)

prepare_questions

echo '<?php' > "$outphp"
echo "defined('_VALID_INCLUDE') or die('Direct access not allowed.');" >> "$outphp"

login=guest
question=1
session=1
machine=demo
studentdir="$outdir/$session/$machine"
mkdir -p "$studentdir"
cd "$studentdir"

# Redefine sql_question not to do SQL ...
sql_question () {
    printf '$demo_questions[] = array("question_text" => "%s",
   "correct_answer" => "%s",
   "coeff" => %s);\n' \
	"$(php_escape "$2")" \
	"$(php_escape "$3")" \
	"$(php_escape "$1")" \
	>> "$outphp"
}

all_questions

echo '?>' >> "$outphp"

(cd "$EXAM_DIR"; git ls-files php | tar cf - -T -) | \
    (cd "$outdir"; tar xf -)
exam_config_php demo > "$outdir"/php/inc/config.php

cd "$outdir"/1
tar czf demo.tar.gz demo/
mv demo.tar.gz ../php

echo "
Generated files:
- $outphp
- $outdir/php/inc/config.php
- $outdir/php/demo.tar.gz

Hopefully, the $output/php/ directory should be ready to be copied on
a webserver to start the demo."
