<?php

defined('_VALID_INCLUDE') or die('Direct access not allowed.');
include_once './inc/config.php';

// slightly adapted from http://php.net/manual/en/features.http-auth.php
$realm = 'Teachers Restricted area';

//user => password
$users = array($exam_webuser => $exam_webpass);


if (!isset($_SERVER['PHP_AUTH_USER'])) {
	header('WWW-Authenticate: Basic realm="'. $realm .'"');
	header('HTTP/1.0 401 Unauthorized');
	die("Sorry, you did not authenticate, I refuse to process the query.\n");
} else {
	if (!isset($users[$_SERVER['PHP_AUTH_USER']]))
		die('Invalid user '. $_SERVER['PHP_AUTH_USER']
		    .'. Try loading https://otherlogin:otherpassword@server.com/path/to/this/file/');
	if ($users[$_SERVER['PHP_AUTH_USER']] != $_SERVER['PHP_AUTH_PW'])
		die('Invalid password for user '. $_SERVER['PHP_AUTH_USER'] .'.');
}
