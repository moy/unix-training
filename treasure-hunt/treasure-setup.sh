# The main machine is the one on which students usually work.
# Students must have access to a shared directory, to which
# we'll upload files corresponding to the steps of the hunt.
mainmachine=telesun.imag.fr

# Some of the steps are on the account of a particular user on
# $mainmachine, but not inside $maindir. This variable is the user's
# login ...
main_user=moy
# ... and this one points to his $HOME directory.
main_user_home=/home/perms/$main_user
# A variant of $main_user_home, to let the player get used to both
# notations
main_user_home_tilde="~${main_user}"

# Directory containing many steps of the hunt. You must have write
# access to it, and students must have read access (but won't be able
# to list the content of the directory).
maindir=$main_user_home/jeu-de-piste
# A variant of $main_user_home, to let the player get used to both
# notations
maindir_tilde=$main_user_home_tilde/jeu-de-piste

# Other machine on which students have access. It will be used to
# practice various basic networking tools (SSH, sftp, ...). Below are
# the machine name and the user on which this part will be installed:
auxiliarymachine=ensilinux.imag.fr
auxiliary_user=$main_user

# The content of this directory should be uploaded to a website
web=$HOME/WWW/jeu-de-piste

# Public URL of the website
web_url=http://www-verimag.imag.fr/~moy/jeu-de-piste

# Demo version of the exam, accessible to students (french and english versions)
demo_url=http://www-verimag.imag.fr/~moy/demo-exam-ensimag2011/
demo_url_en=http://www-verimag.imag.fr/~moy/demo-exam-ensimag2011-en/

# URL of the monitoring system.
spy_url=http://www-verimag.imag.fr/~moy/monitoring-jdp

export mainmachine maindir auxiliarymachine web web_url
export auxiliary_user
export demo_url demo_url_en spy_url
export main_user_home main_user main_user_home_tilde maindir_tilde
