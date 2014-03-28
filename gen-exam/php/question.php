<?php 
define('_VALID_INCLUDE', TRUE);
include_once 'inc/common.php';

exam_header();

if (isset($answer)) {
	set_answer($answer, $machine, $session, $subject, $question);
}

$line = get_answer($question, $machine, $session, $subject);
?>
	<form action="question.php" method="get">
		<fieldset class="invisiblefieldset">
		<input type="hidden" name="question" value="<?php echo $question ?>" />
		<?php 
$form_array = get_form_array($question);
if ($form_array != null) {
	$form = '';
	$selected = false;
	foreach($form_array as $key => $value) {
		$text = '&nbsp;&nbsp;';
		if ($line["student_answer"] == $key) {
			$text = '<strong>X</strong>';
			$selected = true;
		}
		echo '<button type="submit" name="answer" value="'.
			htmlspecialchars($key) . '">'.
			$text . '</button>'. htmlspecialchars($value) . '<br />';
	}
	echo ' ';
	if ($selected) {
		echo exam_get_string('answer_validated');
	} else {
		echo exam_get_string('click_to_answer');
        }
} else {
	echo '<input type="text" name="answer" value="'. htmlspecialchars($line["student_answer"]) . '" />';
	if ($line["student_answer"] == $line["correct_answer"]) {
		echo_correct('.');
	} elseif ($line["student_answer"] == "") {
		echo '<input type="submit" name="submit" value="'. exam_get_string('submit') .'" />';
	} else {
		echo_incorrect('.');
	        echo '<input type="submit" name="submit" value="'. exam_get_string('retry') .'" />';
	}
}
	?>
        </fieldset>
	</form>
<?php

exam_footer();
?>
