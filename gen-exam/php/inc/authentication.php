<?php
switch($exam_auth) {
case "https":
	// http://vonlind.com/2009/04/php-script-switch-page-to-https/
	if(empty($_SERVER['HTTPS'])) {
		// If not, redirect
		$newurl = 'https://'.$_SERVER['SERVER_NAME'].$_SERVER['REQUEST_URI'];
		header("location: $newurl");
		exit();
	}
	include_once('./inc/authentication-http.php');
	break;
case "http":
	include_once('./inc/authentication-http.php');
	break;
case "none":
	// nothing
	break;
default:
	die("Please set \$exam_auth in inc/config.php");
}
?>