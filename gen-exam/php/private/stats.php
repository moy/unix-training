<?php
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';

if ($mode == 'demo')
   die("No stat available in demo mode");

exam_connect_maybe();
$line = get_exam_info($subject);
$count=$line["count"];
$points=$line["points"];

isset($subject) or die("FATAL ERROR: Subject not specified");


exam_header("Stats for ". htmlspecialchars($line["desc"]));


function display_request_question($name, $query) {
	global $subject;
	display_request($name, "SELECT session, COUNT(*) as ". exam_field('count') ." FROM exam_unix_question ".
			     $query
			     ." AND id_subject = '". $subject ."'"
			." GROUP BY session;");
}

function display_request($name, $query) {
	//echo '<pre>QUERY='. $query .'</pre>';
	$result = exam_query($query);
	echo '<li><strong>'. $name . '</strong>: <ul>';
	$total = 0;
	while ($line=exam_fetch_array($result)) {
		$session = 'Session '. $line['session'];
		echo '<li>'. $session .': '. $line['count'] . '</li>';
		$total += $line['count'];
	}
	echo '<li>Total: '. $total . '</li>';
	echo '</ul></li>';
}

?>
<div class="info"><ul>
<li><strong><?php echo $count ?> questions</strong></li>
<li><strong><?php echo $points ?> points</strong></li>
<li><strong>Current subject:</strong> <?php echo $subject ?></li>
<li><strong>Current session:</strong> <?php echo $session ?></li>
<li><strong>Database:</strong> <?php echo $dbuser .'@'. $dbhost .':'. $dbname; ?></li>
<?php
display_request("Number of students", "SELECT session, COUNT(DISTINCT machine) as ". exam_field('count') ."
FROM exam_unix_question
WHERE id_subject = '". $subject ."'
GROUP BY session;");
display_request_question("Number of answers", "WHERE student_answer IS NOT NULL");
display_request_question("Number of correct answers", "WHERE student_answer = correct_answer");
display_request("Number of points", "SELECT session, SUM(exam_unix_subject_questions.coeff) as ". exam_field('count') ."
FROM exam_unix_question, exam_unix_subject_questions
WHERE student_answer = correct_answer
AND exam_unix_question.id = exam_unix_subject_questions.id_question
AND exam_unix_question.id_subject = exam_unix_subject_questions.id_subject
AND exam_unix_question.id_subject = '". $subject ."'"
		." GROUP BY session;");

?>
</ul></div>

<p><a href="grades.php">See grades</a></p>
<?php exam_footer(); ?>
