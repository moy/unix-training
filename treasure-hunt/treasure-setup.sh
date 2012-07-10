# The main machine is the one on which students usually work.
# Students must have access to a shared directory, to which
# we'll upload files corresponding to the steps of the hunt.
mainmachine=telesun.imag.fr

# Directory containing many steps of the hunt. You must have write
# access to it, and students must have read access (but won't be able
# to list the content of the directory).
maindir=/home/perms/moy/jeu-de-piste

# Other machine on which students have access. It will be used to
# practice various basic networking tools (SSH, sftp, ...)
auxiliarymachine=ensilinux.imag.fr

# The content of this directory should be uploaded to a website
web=$HOME/WWW/jeu-de-piste

# Public URL of the website
web_url=http://www-verimag.imag.fr/~moy/jeu-de-piste

# URL of the monitoring system.
spy_url=http://www-verimag.imag.fr/~moy/monitoring-jdp

export mainmachine maindir auxiliarymachine web web_url
export spy_url
