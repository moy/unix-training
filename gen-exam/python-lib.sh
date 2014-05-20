#!/bin/sh

# Set of functions useful to generate a Python exam.

# Run a piece of code using Python3 conventions.
python3_run () {
    python -c "from __future__ import division
from __future__ import print_function

$1"
}

# Print a big array literal
python_big_array() {
    printf '['
    for i in $(seq 9); do
	printf '\n    '
	for j in $(seq 0 9); do
	    printf '%s, ' "${dechashes[$i$j]}"
	done
	if [ $i = 6 ]
	then
	    printf '\n    7175, 5648, 2345, 42, 105, 8447, 2562, 9944, 1677, 6995,'
	fi
    done
    echo "42]" 
}

python_numpy_array() {
    printf "numpy.array([\n"
    for k in $(seq 0 5); do
	for i in $(seq 9); do
	    python_print_line
	    echo ','
	done
    done
    python_print_line
    echo "])"
}

python_print_line() {
    printf '        ['
    for k in $(seq 0 5); do
	for j in $(seq 0 9); do
	    printf '%s, ' "${dechashes[$i$j]}"
	done
    done
    printf "${dechashes[$i]}]"
}
