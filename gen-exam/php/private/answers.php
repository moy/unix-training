<?php
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';
include_once './inc/authentication.php';

if ($mode == 'demo')
	die("No answer available in demo mode");

if ($mode == "sql") {
	isset($subject) or die("FATAL ERROR: Subject not specified, please check config.php.");
	isset($session) or die("FATAL ERROR: Session not specified, please check config.php.");
}

$line = get_exam_info($subject);

exam_header(htmlspecialchars($line["desc"]), '..');

if (isset($_GET['login'])) {
	$login = $_GET['login'];
} else {
	$login = '';
}

?>
<form action="answers.php" method="get">
	<fieldset class="invisiblefieldset">
	Login : <input type="text" name="login" value="<?php echo htmlspecialchars($login) ?>" />
	<input type="submit" value="Get Answers" />
	</fieldset>
</form>
<?php

$count=$line["count"];
$points=$line["points"];

if ($login == "") {
	exam_footer();
	exit;
}
$line = get_login_info($login, $subject);

$machine = $line['machine'];
$session = $line['session'];
$first_name = $line['first_name'];
$familly_name = $line['familly_name'];

if ($machine == "")
	die("FATAL ERROR: Can not find login $login for subject $subject in database");
?>

<?php echo $welcome_msg ?>

<div class="info"><ul>
<li><strong>Machine: <?php echo htmlspecialchars($machine) ?></strong></li>
<li><strong>Session: <?php echo htmlspecialchars($session) ?></strong></li>
<li><strong>Login: <?php echo htmlspecialchars($login) ?></strong></li>
<li><strong>Name: <?php echo htmlspecialchars($first_name ." ". $familly_name) ?></strong></li>
<li><strong><?php echo $count ?> questions</strong></li>
<li><strong><?php echo $points ?> points</strong></li>
</ul></div>
<?php

$total_score = 0;

// List questions.
foreach (get_questions($machine, $session, $subject) as $line) {
	echo '<div class="question">';
	echo "<p><strong>(". $line["coeff"] ." points)</strong>&nbsp;\n";
	echo $line["question_text"] ."</p>\n";
	
	echo '<div style="float: left; background-color: white; padding: .3ex; border: solid 1px grey; width: 10em"><strong>&nbsp;'. $line["student_answer"] ."</strong></div>";
	if ($line["student_answer"] == $line["correct_answer"]) {
		echo_correct('..');
		$total_score += $line["coeff"];
	} elseif ($line["student_answer"] == "") {
		echo ' (pas de réponse)';
	} else {
		echo_incorrect('..');
	}
	// Uncomment to see answers.
	// Disabled by default for security reasons.
	// echo " (". $line["correct_answer"] ." attendu)";

	echo '<div style="clear: both;"></div>';

	echo "</div>\n";
}

echo "<div class=\"info\"><strong>Total score: ". $total_score ."/". $points ." points.</strong></div>\n";

exam_footer();
?>
