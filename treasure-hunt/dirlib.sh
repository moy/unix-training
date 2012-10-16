. uuidlib.sh

# Create noise in current directory.
make_subdirs () {
    for i in a b $(seq $(($RANDOM % 7))); do
        mkdir -p $(uuid | sed 's/..........$//')
    done
    for i in c d $(seq $(($RANDOM % 5))); do
        mkdir -p $RANDOM
    done
    for i in e f $(seq $(($RANDOM % 7))); do
        uuid > $(uuid | sed 's/........$//')
	echo "Attention, ceci n'est pas la réponse. Mais ça devrait décourager
les gens qui voudraient essayer 'grep reponse' ;-).

La réponse est $RANDOM .
La reponse est $RANDOM ." > $(uuid | sed 's/..........$//')
    done
}

make_big_dir () {
    for i in $(seq "${1:-20}"); do
	mkdir -p $RANDOM
    done
    
    echo "toplevel bigdir created"

    for dir in */; do
	(
	    cd "$dir"
	    make_subdirs
	)
    done

    echo "subdirs created in bigdir"
}

# create noise in directories $1, $1/.., $1/../.. up to the current
# directory.
make_subdirs_back () {
    (
	orig=$(pwd -P)
	cd "$1"
	while [ "$(pwd -P)" != "$orig" ]; do
	    make_subdirs
	    cd ..
	done
    )
}

make_one_dir () {
    dir=$RANDOM/$(uuid)/$(uuid)/
    mkdir -p "$dir"
    make_subdirs_back "$dir"
    echo "$dir"
}

make_one_file () {
    dir=$RANDOM/$(uuid)
    file=$dir/${1:-$RANDOM}
    mkdir -p "$dir"
    touch "$file"
    make_subdirs_back "$dir"
    echo "$file"
}
