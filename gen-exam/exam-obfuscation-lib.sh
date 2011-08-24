# Set the PATH to let scripts sources other ones.
HUNT_DIR=$(cd "$EXAM_DIR"/../treasure-hunt && pwd)
PATH="$HUNT_DIR":"$PATH"
. adalib.sh
. latexlib.sh
. dirlib.sh
. textlib.sh
. imglib.sh
. odtlib.sh
