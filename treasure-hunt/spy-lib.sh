#! /bin/sh

. ./treasure-setup.sh

monitor_step_cmd () {
    printf 'wget "%s/record.php?login=\$LOGNAME&step=%s" -O /dev/null 2>/dev/null &\n' \
	"$spy_url" "$1"
}
