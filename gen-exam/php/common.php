<?php
defined('_VALID_INCLUDE') or die('Direct access not allowed.');

function exam_header($title = '') {
	echo '<'.'?xml version="1.0" encoding="UTF-8" ?'.'>';
 	?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
	<meta name="author" content="Matthieu Moy" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $title ?></title>
	<style type="text/css">
	@import "./style.css";
	</style>
</head>
<body>
	<?
	  if ($title != '') {
		  echo "<h1>$title</h1>";
	  }
}

function exam_footer() {
	echo '</body></html>';
}

$question = $_GET["question"];
//$machine = $_GET["machine"];
if (isSet($_SERVER["HTTP_X_FORWARDED_FOR"])) {
	$IP = $_SERVER["HTTP_X_FORWARDED_FOR"];
} else {
	$IP = $_SERVER["REMOTE_ADDR"];
}
$machine = gethostbyaddr($IP);

include_once('./config.php');

if (isset($_GET["answer"])) {
	$answer = trim($_GET["answer"]);
}

if (!isset($mode)) {
	$mode = "sql";
}

if ($mode == "demo") {
	include_once "./common-demo.php";
} else {
	include_once "./common-sql.php";
}

?>