#! /bin/sh

escape_c_string () {
    sed -e 's/[\\"]/\\\0/g' \
	-e 's/%/%%/g'
}
