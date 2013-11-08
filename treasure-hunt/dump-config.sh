#!/bin/sh

. ./treasure-setup.sh

for v in $(echo $variables)
do
    eval "echo $v=\$$v"
done

