# The main machine is the one on which students usually work.
# Students must have access to a shared directory, to which
# we'll upload files corresponding to the steps of the hunt.
mainmachine=ensiens.imag.fr

# Some of the steps are on the account of a particular user on
# $mainmachine, but not inside $maindir. This variable is the user's
# login ...
main_user=moy
# ... and this one points to his $HOME directory.
main_user_home=/home/ensiens.imag.fr/$main_user
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

# In my setup, the students access $main_user_home with a path
# different from the one I'm using to upload. If this is not your
# case, uncomment the line to set
# main_user_home_upload=$main_user_home.
main_user_home_upload=/export/ensiens.imag.fr/moy/
# main_user_home_upload=$main_user_home
maindir_upload=$main_user_home_upload/jeu-de-piste

# Other machine (server) on which students have access. It will be
# used to practice various basic networking tools (SSH, sftp, ...).
# Below are the machine name and the user on which this part will be
# installed:
auxiliarymachine=telesun.imag.fr
auxiliary_user=$main_user

# The content of this directory should be uploaded to a website
web=$HOME/WWW/jeu-de-piste

# Public URL of the website
web_url=http://www-verimag.imag.fr/~moy/jeu-de-piste

# Demo version of the exam, accessible to students (french and english versions)
demo_url=http://www-verimag.imag.fr/~moy/demo-exam-ensimag2012/
demo_url_en=http://www-verimag.imag.fr/~moy/demo-exam-ensimag2012-en/

# One step sends an email to the user. The following variables
# configure how the email will be sent:
from_addr=Matthieu.Moy@imag.fr
smtp_server=telesun.imag.fr
# and these two configure how the email will be prompted obtained from
# $LOGNAME and possibly by prompting the user.
get_email_function=get_email_ensimag
check_email_function=check_email_ensimag

# URL of the monitoring system.
spy_url=http://www-verimag.imag.fr/~moy/monitoring-jdp

# I upload the game on multiple machines, with slightly different rules
case "$mainmachine" in
    ensiens|ensiens.imag.fr)
	: nothing
	;;
    *)
	main_user_home=/home/perms/$main_user
	maindir=$main_user_home/jeu-de-piste
	main_user_home_upload=$main_user_home
	maindir_upload=$main_user_home_upload/jeu-de-piste
	;;
esac

export mainmachine maindir auxiliarymachine web web_url
export auxiliary_user
export demo_url demo_url_en spy_url
export main_user_home main_user main_user_home_tilde maindir_tilde
export from_addr smtp_server get_email_function check_email_function
