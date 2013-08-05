#! /bin/sh

packages_to_install=""

check () {
    package="${2:-$1}"
    if ! command -v "$1" >/dev/null; then
	echo "$1: Command does not seem available, please install it."
	packages_to_install="$packages_to_install $package"
    else
	echo "$1: OK"
    fi
}

check recode
check a2ps
check zip
check unzip
check gnatmake gnat
check convert imagemagick
check gettext gettext-base
check git
check pdflatex texlive-latex-base
check gcc
check perl
check rsync

if [ -n "$packages_to_install" ]; then
    echo
    echo "You may want to run something like this to fix the errors:"
    echo "  sudo aptitude install$packages_to_install"
fi
