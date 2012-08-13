#! /bin/bash

PATH=..:$PATH

. adalib.sh

# Redirect the output to encoded_file.adb
exec > encoded_file.adb

echo "To make a comment in ada, print text and
pipe it to ada_comment_out
" | ada_comment_out

# This is mandatory. It will generate with and use statements needed
# for the decoding
adawithuse

echo "procedure Encoded_File is"

# This is also mandatory, and must come before the "procedure" and
# "begin". It will generate the decoding code.
adadecode

echo "begin"

echo "Obfuscated code follows" | ada_comment_out

echo "Then, the text to be obfuscated should be displayed and piped into ada_obfuscate.

The text can be multi-line. Each line will lead to an (unreadable)
put_line statement." | ada_obfuscate

# If you want the file to be long, you may use "Noise", which just
# displays dead code.
echo "Below, some added noise" | ada_comment_out
Noise
Noise

# Finish the function
echo "end;"

echo "encoded_file.adb generated" >&2
