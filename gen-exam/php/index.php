<?php
define('_VALID_INCLUDE', TRUE);
include_once 'inc/common.php';

if ($mode == "sql") {
	isset($subject) or die("FATAL ERROR: Subject not specified, please check config.php.");
	isset($session) or die("FATAL ERROR: Session not specified, please check config.php.");
}

$line = get_exam_info($subject);

exam_header(htmlspecialchars($line["desc"]));

if ($mode == "demo") {
	echo "<p><strong>". exam_get_string('demo_warning') ."</strong></p>";
	echo '<p><a href="?reset=yes&amp;mode=demo">'. exam_get_string('reset_answers') .'</a></p>';
}

if (subject_file_exists()) {
	echo '<p>'. exam_get_string('download_subject_here') .'<a href="download-subject.php">'.
		htmlentities($subject_basename) .'</a>.</p>';
}

/*
echo '<pre>';
var_dump($_SESSION['demo_questions']);
echo '</pre>';
*/

$count=$line["count"];
$points=$line["points"];

$line = get_login($machine, $session, $subject);
$login = $line['login'];
$first_name = $line['first_name'];
$familly_name = $line['familly_name'];

if ($login == "")
	die("FATAL ERROR: Can not find login in database (subject=$subject, session=$session, machine=$machine).");
?>

<?php echo $welcome_msg ?>

<div class="info"><ul>
<li><strong><?php echo exam_get_string('machine') .': '. $machine ?></strong></li>
<li><strong><?php echo exam_get_string('session') .': '. $session ?></strong></li>
<li><strong><?php echo exam_get_string('login') .': '. $login ?></strong></li>
<li><strong><?php echo exam_get_string('name') .': '. $first_name ." ". $familly_name ?></strong></li>
<li><strong><?php echo $count ." ". exam_get_string('questions') ?></strong></li>
<li><strong><?php echo $points ." ". exam_get_string('points') ?></strong></li>
</ul></div>
<?php

$hideok = isset($_GET['hideok']);
$question_displayed = 0;

// List questions.
foreach (get_questions($machine, $session, $subject, $hideok) as $line) {
	$question_displayed++;
	echo '<div class="question">';
	echo "<p><strong>(". $line["coeff"] ." points)</strong>&nbsp;\n";
	echo $line["question_text"] ."</p>\n";
// iframe is deprecated in XHTML Strict, but works in old Konqueror
// versions, while forms inside <object> do not seem to.
	echo '<iframe class="submitbox" style="border: 0;" src="question.php?question='. $line["question"]
//	echo '<object class="submitbox" type="text/html"  data="question.php?question='. $line["question"]
		.'">\n';
//	echo "</object><br />\n";
        echo "</iframe><br />\n";
	echo "</div>\n";
}

if ($question_displayed === 0) {
	echo '<p><strong>' . exam_get_string('all_ok') . '</strong></p>'; 
}

// If $exam_footer_include is set in config.php, include it.

if (isset($exam_footer_include) && $exam_footer_include) {
	// allow only simple filenames, to make sure
	// /etc/passwd, ../../etc/passwd or http://whatever
	// are not allowed.
	if (! preg_match('/^[a-zA-Z0-9\.-]*$/', $exam_footer_include)) {
		die("\$exam_footer_include should only contain letters, digits, dots and dashes");
	}
	// belt-and-suspenders security check.
	// include($variable) makes me nervous ...
	if (! file_exists('inc/' . $exam_footer_include)) {
		die("File 'inc/". $exam_footer_include ."' does not exist, sorry.");
	}
	include('inc/' . $exam_footer_include);
}

if (isset($_GET['n'])) {
	$n = intval($_GET['n']) + 1;
} else {
	$n = 0;
}
echo '  <div class="info">';
echo '    <a href="?n='. $n .'&amp;hideok">'. exam_get_string('hide_correct') .'</a>';
if ($hideok) {
	echo ' | <a href="?n='. $n .'">'. exam_get_string('display_correct') .'</a>';
}
echo '  </div>';
exam_footer(); ?>
