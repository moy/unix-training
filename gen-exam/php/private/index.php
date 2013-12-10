<?php
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';
include_once './inc/authentication.php';

exam_header('Private part of the exam', '..');

foreach(scandir("private") as $entry) {
	if (preg_match('/\.php$/', $entry) &&
		$entry != "index.php") {
		echo '<a href="' . htmlspecialchars($entry) . '">'
			. htmlspecialchars($entry) . '</a><br />';
	}
}

exam_footer();
?>
