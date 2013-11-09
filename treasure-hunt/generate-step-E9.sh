#! /bin/sh

. ./treasure-setup.sh
. ./i18n-lib.sh

cat > $(gettext etape)-E9.php <<EOF
<?php
if (preg_match('/^[a-z][a-zA-Z0-9]*\$/', \$_GET['login'])) {
	// the monitoring system may be down, we still want the step to work
	error_reporting(0);
	file_get_contents('$spy_url/record.php?login='. \$_GET['login'] .'&step=E9');
	header('location: $web_url/yntsf/$(gettext etape)-E10.txt');
	exit();
}
?>
<?php echo '<?xml version="1.0" encoding="UTF-8" ?>'; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta name="author" content="Matthieu Moy" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>$(gettext Etape) E9</title>
	<style type="text/css">
	@import "../style.css";
	</style>
</head>
<body>
<form name="input" action="$(gettext etape)-E9.php" method="get">
$(gettext "Quel est votre login \${school}? :" | envsubst) <input type="text" name="login" />
<input type="submit" value="OK" />
</form>
</body>
</html>
EOF
