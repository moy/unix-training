#! /bin/sh

# Usage:
# echo 'some text' | txt2img file.png
# echo 'another text' | txt2img file.jpg 12
txt2img () {
    mv -f "$1" "$1"~
    recode utf-8..latin1 | \
	a2ps -1 --font-size="${2:-16}" --landscape -o - | \
	convert -rotate 90 - "$1"
    if [ ! -f "$1" ]; then
	echo "Conversion failed (more than 1 page?)"
	exit 1
    fi
}
