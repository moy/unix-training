<?php 
define('_VALID_INCLUDE', TRUE);
chdir('..');
include_once './inc/common.php';
include_once './inc/authentication.php';

if ($mode == 'demo')
   die("Grades cannot be computed in demo mode");

exam_connect_maybe();

isset($subject) or die("FATAL ERROR: Subject not specified");

// We could try SUM(exam_unix_subject_questions.coeff), and GROUP BY
// login if we put exam_unix_question.correct_answer =
// exam_unix_question.student_answer directly in the WHERE clause.
// but this raises two problems :
// - We can't easily display the names, since they don't appear in
//   GROUP BY (on purpose, students can have the same name but not the
//   same login)
// - Students with grade 0 won't appear at all.
// Instead, we move the logic from SQL to PHP.
$query = "SELECT exam_unix_subject_questions.coeff as ". exam_field('grade') .",
                 exam_unix_logins.login as ". exam_field('login') .",
                 exam_unix_logins.first_name as ". exam_field('first_name') .",
                 exam_unix_logins.familly_name as ". exam_field('familly_name') .",
                 exam_unix_question.student_answer as ". exam_field('student_answer') .",
                 exam_unix_question.correct_answer as ". exam_field('correct_answer') ."
FROM exam_unix_subject, exam_unix_subject_questions, exam_unix_question, exam_unix_logins
WHERE exam_unix_subject_questions.id_subject  = exam_unix_subject.id
  AND exam_unix_subject_questions.id_question = exam_unix_question.id
  AND exam_unix_subject.id = exam_unix_question.id_subject
  AND exam_unix_logins.machine = exam_unix_question.machine
  AND exam_unix_logins.session = exam_unix_question.session
  AND exam_unix_logins.id_subject = exam_unix_subject.id
  AND exam_unix_subject.id = '". exam_escape_string($subject) ."'
 -- AND exam_unix_question.correct_answer = exam_unix_question.student_answer
ORDER BY exam_unix_logins.login
";
$result = exam_query($query);

header("Content-type: text/plain;charset=utf-8");

echo "login;first name;familly name;grade\n";
$previous_login=NULL;
$previous_first_name=NULL;
$previous_familly_name=NULL;
$accumulated_grade=0;
function display_and_flush() {
	global $previous_login, $previous_familly_name, $previous_first_name, $accumulated_grade;
	echo $previous_login .";". $previous_first_name .";". $previous_familly_name .";".
		$accumulated_grade ."\n";
	$accumulated_grade = 0;
}

while ($line = exam_fetch_array($result, null, PGSQL_ASSOC)) {
	if (isset($previous_login)) {
		if ($line["login"] != $previous_login) {
			display_and_flush();
		} else {
			if ($line["first_name"] != $previous_first_name) {
				die("Different first names (". $line["first_name"] ." and ". $previous_first_name .") for the same login");
			}
			if ($line["familly_name"] != $previous_familly_name) {
				die("Different familly names (". $line["familly_name"] ." and ". $previous_familly_name .") for the same login");
			}
		}
	}
	if ($line["student_answer"] == $line["correct_answer"]) {
		$accumulated_grade += $line["grade"];
	}
	$previous_login = $line["login"];
	$previous_first_name = $line["first_name"];
	$previous_familly_name = $line["familly_name"];
}
display_and_flush();
?>
