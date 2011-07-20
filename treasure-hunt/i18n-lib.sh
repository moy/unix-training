#! /bin/sh

export TEXTDOMAINDIR=$(pwd)
# By default, use domain XX for generate-step-XX.sh
export TEXTDOMAIN=$(echo "$0" | sed 's/.*generate-step-\(.*\).sh.*/\1/g')
#debug:
#echo TEXTDOMAIN=$TEXTDOMAIN

. gettext.sh
