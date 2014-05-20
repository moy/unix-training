# First loop through arguments for options common to both modes.
for arg in "$@"; do
    case "$arg" in
	"--demo")
	    exam_mode=demo
	    ;;
	"--zip")
	    preferred_archive=zip
	    ;;
    esac
done

if [ "$preferred_archive" = "" ]; then
    preferred_archive=tar.gz
fi

case "$exam_lang" in
    fr|en)
	: OK
	;;
    "")
	# Silently switch to default
	exam_lang=en
	;;
    *)
	echo "WARNING: unsupported language $exam_lang."
	exam_lang=en
	;;
esac

if [ "$exam_mode" = "demo" ]; then
    echo "Generating the exam in demo mode (because of --demo)"
    . "$EXAM_DIR"/gen-exam-demo.sh
else
    echo "Generating the exam in SQL mode (use --demo for demo mode)"
    . "$EXAM_DIR"/gen-exam-sql.sh
fi
