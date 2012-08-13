#! /bin/bash

PATH=..:$PATH

. c-lib.sh

# Redirect the output to encoded_file.adb
exec > encoded_file.c

c_dprint_header

echo "Some text to be obfuscated.

This may be multi-line
text." | c_obfuscate_full
