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
?><input type="text" name="answer" value="<?php echo htmlspecialchars($line["student_answer"]) ?>" />
	<?php
	if ($line["student_answer"] == $line["correct_answer"]) {
		echo_correct('.');
	} elseif ($line["student_answer"] == "") {
		echo '<input type="submit" name="submit" value="Soumettre" />';
	} else {
		echo_incorrect('.');
	        echo '<input type="submit" name="submit" value="Réessayer" />';
	}
	?>
        </fieldset>
	</form>
<?php

exam_footer();
?>
