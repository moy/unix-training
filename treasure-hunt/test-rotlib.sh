#! /bin/sh

. ./rotlib.sh

echo abcdefghijklmnopqrstuvwxyz1234567890 | rotpipe | unrotpipe
