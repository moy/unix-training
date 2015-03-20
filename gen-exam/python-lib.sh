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
    printf '\n    1,2,     4,   -23,    5,      5432,                       666,   108,'
    for i in $(seq 9) $(seq 9); do # We can't go above 9 to allow dechashes[$i$j].
	printf '\n    '
	for j in $(seq 0 $(dechash_bound "$1$i" 40)); do
	    printf '%s, ' "${dechashes[$i$j]}"
	done
	if [ $i = 8 ]
	then
	    printf '\n    7175, 5648, 2345, 42, 105, -8447, 2562, 9944, 1677, 6995,'
	fi
    done
    printf '\n    1,2,\n    4,\n    23,    -555,      5432,                       -666,   114,'
    echo "42]" 
}

python_big_string() {
    printf '("blablabla"'
    for i in $(seq 9) $(seq 9); do
	for j in $(seq 9); do
	    printf '+ "%s"' "${hashes[$i]}${dechashes[$i$j]}ii"
	done
	if [ $i = 7 ]
	then
	    printf '+ "%s" + "%s"' "${hashes[$i]}ic" "i${dechashes[$i$j]}"
	fi
	for j in $(seq 9); do
	    printf '+ "%s"' "${hashes[$j]}i${dechashes[$i$j]}"
	done
	printf '\n'
    done
    printf ")"
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
