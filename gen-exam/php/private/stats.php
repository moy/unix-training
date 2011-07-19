<?php
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';
include_once './inc/authentication.php';

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
	echo '<li><strong>'. $name . "</strong>: <ul>\n";
	$total = 0;
	while ($line=exam_fetch_array($result)) {
		$session = 'Session '. $line['session'];
		echo '    <li>'. $session .': '. $line['count'] . "</li>\n";
		$total += $line['count'];
	}
	echo '    <li>Total: '. $total . "</li>\n";
	echo "</ul></li>\n";
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

// TODO: it would be nice to have a notion of "question id" (first
// argument of smart_question), but it's not stored in the database.
$query="SELECT exam_unix_subject_questions.id_question AS ". exam_field('id_question') .",
               COUNT(exam_unix_subject_questions.coeff) AS ". exam_field('score') .",
               MAX(exam_unix_question.question_text) AS ". exam_field('question') ."
FROM exam_unix_subject_questions, exam_unix_question
WHERE student_answer = correct_answer
AND exam_unix_question.id = exam_unix_subject_questions.id_question
AND exam_unix_question.id_subject = exam_unix_subject_questions.id_subject
AND exam_unix_question.id_subject = '". $subject ."'"
	." GROUP BY exam_unix_subject_questions.id_question
           ORDER BY score;";
$result = exam_query($query);
echo "<li><strong>Per-question correct answers</strong>: <ul>\n";
$total = 0;
while ($line=exam_fetch_array($result)) {
	$session = 'Question '. $line['id_question'];
	if ($_GET['verbose'] === 'yes') {
		$details = ' ('. $line['question'] .')';
	} else {
		$details = '';
	}
	echo '    <li>'. $session . $details . ' : '. $line['score'] . "</li>\n";
	$total += $line['score'];
}
echo '    <li>Total: '. $total . "</li>\n";
echo "</ul></li>\n";

?>
</ul></div>

<p><a href="grades.php">See grades</a></p>
<p><a href="answers.php">See student's answers</a></p>
<?php if ($_GET['verbose'] === 'yes') { ?>
    <p><a href="?verbose=no">See non-verbose stats</a></p>
<?php } else { ?>
    <p><a href="?verbose=yes">See verbose stats</a></p>
<?php }
exam_footer(); ?>
