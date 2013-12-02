#! /bin/sh

# URL to adapt for your setup
url='http://login:passord@ensiunix1.imag.fr/exam2013/private/dump.php';

for i in $(seq 30); do
    wget "$url" -O dump-$(date +'%Y-%m-%d--%H:%M').sql
    sleep 600
done
