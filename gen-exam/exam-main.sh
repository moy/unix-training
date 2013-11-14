if [ "$1" = "--demo" ]; then
    shift
    exam_mode=demo
fi

if [ "$exam_mode" = "demo" ]; then
    echo "Generating the exam in demo mode (because of --demo)"
    . "$EXAM_DIR"/gen-exam-demo.sh
else
    echo "Generating the exam in SQL mode (use --demo for demo mode)"
    . "$EXAM_DIR"/gen-exam-sql.sh
fi
