#! /bin/bash

telehome=$(ssh "$mainmachine" pwd)
telekeys=$(ssh "$mainmachine" cat .ssh/authorized_keys)

(printf '%s' "command=\"$telehome/jeu-de-piste/etape-H9.sh\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding ";
    cat id_rsa_etape_H9.pub) > authorized_keys_H9

if echo "$telekeys" | grep -q jeu-de-piste; then
    echo "$telekeys" > authorized_keys
else
    (echo "$telekeys"; cat authorized_keys_H9) > authorized_keys
fi
chmod 600 authorized_keys
rsync -av authorized_keys "$mainmachine":.ssh/authorized_keys
rm -f authorized_keys_H9 authorized_keys
