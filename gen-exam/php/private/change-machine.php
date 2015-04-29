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

if (isset($_GET['machine_to_edit'])) {
	$machine_to_edit = $_GET['machine_to_edit'];
} else {
	$machine_to_edit = '';
}

if (isset($_GET['session_to_edit'])) {
	$session_to_edit = $_GET['session_to_edit'];
} else {
	$session_to_edit = '';
}

?>
<form action="change-machine.php" method="get">
	<fieldset class="invisiblefieldset">
	Machine : <input type="text" name="machine_to_edit" value="<?php echo htmlspecialchars($machine_to_edit) ?>" />
	Session : <input type="text" name="session_to_edit" value="<?php echo htmlspecialchars($session_to_edit) ?>" />
	<input type="submit" value="Get information" />
	</fieldset>
</form>
<?php

if ($machine_to_edit == "" || $session_to_edit == "") {
	exam_footer();
	exit;
}

$new_login = "";
$new_first_name = "";
$new_familly_name = "";
$new_student_id = "";

if (isset($_GET['new_login'])) {
	$new_login = $_GET['new_login'];
}
if (isset($_GET['new_first_name'])) {
	$new_first_name = $_GET['new_first_name'];
}
if (isset($_GET['new_familly_name'])) {
	$new_familly_name = $_GET['new_familly_name'];
}
if (isset($_GET['new_student_id'])) {
	$new_student_id = $_GET['new_student_id'];
}

if ($new_login != "") {
	exam_query("UPDATE exam_unix_logins
                    SET login = '". exam_escape_string($new_login) ."',
                   first_name = '". exam_escape_string($new_first_name) ."',
                 familly_name = '". exam_escape_string($new_familly_name) ."',
                   student_id = '". exam_escape_string($new_student_id) ."'
                WHERE machine = '". exam_escape_string($machine_to_edit) ."'
                  AND session = '". exam_escape_string($session_to_edit) ."'
               AND id_subject = '". exam_escape_string($subject) ."'") or die ("Failed to change info for $login");
	echo "<p>Information updated for $machine_to_edit on session $session_to_edit.</p>\n";
} else {
	echo "<p>Nothing to update.</p>\n";
}

$line = get_login($machine_to_edit, $session_to_edit, $subject);

$login = $line['login'];
$first_name = $line['first_name'];
$familly_name = $line['familly_name'];
$student_id = $line['student_id'];
$initial_login = $line['initial_login'];
$initial_first_name = $line['initial_first_name'];
$initial_familly_name = $line['initial_familly_name'];
$initial_student_id = $line['initial_student_id'];

if ($login == "")
	die("FATAL ERROR: Can not find login $login for subject $subject in database");

function display_was($old, $new) {
	if ($old == $new) {
		echo '(unchanged)';
	} else {
		echo '(was <strong>'. htmlspecialchars($old) .'</strong>)';
	}
}
?>

<form action="change-machine.php" method="get">
	<fieldset class="invisiblefieldset">
	<input type="hidden" name="machine_to_edit" value="<?php echo htmlspecialchars($machine_to_edit) ?>" />
	<input type="hidden" name="session_to_edit" value="<?php echo htmlspecialchars($session_to_edit) ?>" />
	<div class="info"><ul>
	<li><strong>Machine: <?php echo htmlspecialchars($machine_to_edit) ?></strong></li>
	<li><strong>Session: <?php echo htmlspecialchars($session_to_edit) ?></strong></li>
	<li><strong>Login</strong>:
	    <input type="text" name="new_login" value="<?php echo htmlspecialchars($login) ?>" />
	    <?php display_was($initial_login, $login); ?></li>
	<li><strong>First Name</strong>:
	    <input type="text" name="new_first_name" value="<?php echo htmlspecialchars($first_name) ?>" />
	    <?php display_was($initial_first_name, $first_name); ?></li>
	<li><strong>Familly Name</strong>:
	    <input type="text" name="new_familly_name" value="<?php echo htmlspecialchars($familly_name) ?>" />
	    <?php display_was($initial_familly_name, $familly_name); ?></li>
	<li><strong>Student ID</strong>:
	    <input type="text" name="new_student_id" value="<?php echo htmlspecialchars($student_id) ?>" />
	    <?php display_was($initial_student_id, $student_id); ?></li>
	</ul></div>
	<input type="submit" value="Change information" />
	</fieldset>
</form>

<p><a href="stats.php">See stats</a></p>
<?php
exam_footer();
?>
