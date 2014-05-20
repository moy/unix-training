#!/bin/bash

EXAM_DIR=..
. $EXAM_DIR/exam-api.sh
. $EXAM_DIR/python-lib.sh

(
    echo "import numpy"
    printf "M = "
    python_numpy_array
    echo "print(M[1][1])"
) | python -
