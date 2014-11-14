<?php
defined('_VALID_INCLUDE') or die('Direct access not allowed.');

/* (trivial) portability layer. PostgreSQL specific stuff go here */
switch ($dbtype) {
case "postgresql":
	function exam_escape_string($str) {
		if (get_magic_quotes_gpc())
			return pg_escape_string(stripslashes($str));
		else
			return pg_escape_string($str);
	}

	// Don't rely on isset(), since $dbconn may come from $_GET
	// parameters ...
	$dbconn = NULL;
	function exam_connect_maybe() {
		global $dbconn, $dbhost, $dbname, $dbuser, $dbpass;
		if ($dbconn == NULL) {
			$dbconn_string = "host=". $dbhost
				." dbname=". $dbname
				." user=". $dbuser
				." password='". $dbpass ."'";
			$dbconn = pg_connect($dbconn_string) or die("Cannot connect to the database, sorry.");;
			pg_set_client_encoding("UTF8");
		}
	}

	function exam_query($query) {
		return pg_query($query);
	}

	function exam_num_rows($result) {
		return pg_num_rows($result);
	}

	function exam_fetch_array($result) {
		return pg_fetch_array($result);
	}

	function exam_field($name) {
		return $name;
	}

	function exam_dump() {
		 global $dbhost, $dbuser, $dbpass, $dbname;
		 echo "-- *** WARNING: Untested feature *** dump in PostgreSQL ***\n";
		 $command = "PGPASSWORD='$dbpass' pg_dump -h $dbhost -U $dbuser -d $dbname";
		 system($command);
	}

	break;
case "mysql":
	function exam_escape_string($str) {
		if (get_magic_quotes_gpc())
			return mysql_real_escape_string(stripslashes($str));
		else
			return mysql_real_escape_string($str);
	}

	// Don't rely on isset(), since $dbconn may come from $_GET
	// parameters ...
	$dbconn = NULL;
	function exam_connect_maybe() {
		global $dbconn, $dbhost, $dbname, $dbuser, $dbpass;
		if ($dbconn == NULL) {
			$dbconn = mysql_connect($dbhost, $dbuser, $dbpass) or die("Cannot connect to the database, sorry.");;
			mysql_select_db($dbname, $dbconn) or die("Unable to select database");
			mysql_set_charset("UTF8");
		}
	}

	function exam_query($query) {
		$result = mysql_query($query) or die("SQL Query failed: ". mysql_error());
		return $result;
	}

	function exam_num_rows($result) {
		return mysql_num_rows($result);
	}

	function exam_fetch_array($result) {
		return mysql_fetch_array($result);
	}

	function exam_field($name) {
		return "'". $name ."'";
	}
	
	function exam_dump() {
		 global $dbhost, $dbuser, $dbpass, $dbname;
		 $command = "mysqldump --opt -h $dbhost -u $dbuser -p$dbpass $dbname";
		 system($command);
	}

	break;
}
/* end of portability layer */

function get_exam_info($subject) {
	exam_connect_maybe();
	$query = "SELECT exam_unix_subject.descriptif AS ". exam_field('desc') .",
                 COUNT(*) AS ". exam_field('count') .",
		 SUM(exam_unix_subject_questions.coeff) AS ". exam_field('points') ."
FROM exam_unix_subject, exam_unix_subject_questions
WHERE exam_unix_subject.id = exam_unix_subject_questions.id_subject
  AND exam_unix_subject.id = '". exam_escape_string($subject) ."'
GROUP BY exam_unix_subject.descriptif";
	$result = exam_query($query);
	if (exam_num_rows($result) != 1)
		die("FATAL ERROR: Did not find a unique subject");
	return exam_fetch_array($result);
}

function get_questions ($machine, $session, $subject, $hide_correct = False) {
	exam_connect_maybe();
	$query = "SELECT exam_unix_subject_questions.id_question AS question,
                 exam_unix_question.question_text AS question_text,
                 exam_unix_subject_questions.coeff AS coeff,
		 exam_unix_question.student_answer AS student_answer,
		 exam_unix_question.correct_answer AS correct_answer
FROM exam_unix_subject_questions, exam_unix_question
WHERE exam_unix_subject_questions.id_question = exam_unix_question.id
  AND exam_unix_question.machine = '". exam_escape_string($machine) ."'
  AND exam_unix_question.session = '". exam_escape_string($session) ."'
  AND exam_unix_question.id_subject = '". exam_escape_string($subject) ."'
  AND exam_unix_subject_questions.id_subject = exam_unix_question.id_subject
";
	$query .= " ORDER BY exam_unix_subject_questions.coeff, exam_unix_question.correct_answer";
	$result = exam_query($query);
	$questions = array();
	while ($line = exam_fetch_array($result)) {
		if (!$hide_correct ||
		    must_be_shown($line, $machine, $session, $subject)) {
			$questions[] = $line;
		}
	}
	return $questions;
}

function get_form_array($question, $machine, $session, $subject) {
	$query = "SELECT name, value
FROM exam_unix_forms
WHERE exam_unix_forms.id = '". exam_escape_string($question) ."'
  AND exam_unix_forms.machine = '". exam_escape_string($machine) ."'
  AND exam_unix_forms.session = '". exam_escape_string($session) ."'
  AND exam_unix_forms.id_subject = '". exam_escape_string($subject) ."'
";
	$result = exam_query($query) or die("Failed to get form");
	if ($result) {
		$result_array = array();
		while ($line = exam_fetch_array($result)) {
			$result_array[$line['name']] = $line['value'];
		}
		return $result_array;
	} else {
		return null;
	}
}

function get_login ($machine, $session, $subject) {
	exam_connect_maybe();
	$query = "SELECT login, initial_login, first_name, initial_first_name, familly_name, initial_familly_name, student_id, initial_student_id
FROM exam_unix_logins
WHERE id_subject = '". exam_escape_string($subject) ."'
  AND session    = '". exam_escape_string($session) ."'
  AND machine    = '". exam_escape_string($machine) ."'
";
	$result = exam_query($query);
	$line = exam_fetch_array($result);
	return $line;
}

function get_login_info ($login, $subject) {
	exam_connect_maybe();
	$query = "SELECT first_name, familly_name, session, machine
FROM exam_unix_logins
WHERE id_subject = '". exam_escape_string($subject) ."'
  AND login      = '". exam_escape_string($login) ."'
";
	$result = exam_query($query);
	$line = exam_fetch_array($result);
	return $line;
}

function set_answer($answer, $machine, $session, $subject, $question) {
	exam_connect_maybe();
	$query = "UPDATE exam_unix_question
SET student_answer = '". exam_escape_string($answer) ."'
WHERE machine = '".      exam_escape_string($machine) ."'
  AND session = '".      exam_escape_string($session) ."'
  AND id_subject = '".   exam_escape_string($subject) ."'
  AND id = '".           exam_escape_string($question) ."'";
	exam_query($query) or die("Failed to set answer");
}

function get_answer($question, $machine, $session, $subject) {
	exam_connect_maybe();
	$query = "SELECT exam_unix_question.question_text  AS question_text,
		 exam_unix_question.correct_answer AS correct_answer,
		 exam_unix_question.student_answer AS student_answer
 FROM exam_unix_subject, exam_unix_subject_questions, exam_unix_question
WHERE exam_unix_subject_questions.id_subject  = exam_unix_subject.id
  AND exam_unix_subject_questions.id_subject  = exam_unix_question.id_subject
  AND exam_unix_subject_questions.id_question = exam_unix_question.id
  AND exam_unix_question.id      = '". exam_escape_string($question) ."'
  AND exam_unix_question.machine = '". exam_escape_string($machine) ."'
  AND exam_unix_question.session = '". exam_escape_string($session) ."'
  AND exam_unix_subject.id       = '". exam_escape_string($subject) ."'
";

	$result = exam_query($query);
	if (count($result) != 1)
		echo("FATAL ERROR: Bad number of questions (". count($result) .")");

	return exam_fetch_array($result);
}

/* Utility functions */

// Display the result of an SQL query as an HTML table.
function exam_display_result ($result, $format_function=null) {
	$array = exam_fetch_array($result);
	if ($array) {
		$n_res = 0;
		echo '<table class="sortable">';
		echo "<tr>";
		foreach ($array as $key => $value) {
			if (!is_numeric($key)) {
				// we're executing *_fetch_array in
				// default mode, we're getting both
				// the associative array and the
				// numeric indices. Ignore numeric
				// indices.
				echo '<th>'. htmlspecialchars($key) .'</th>';
			}
		}
		echo "</tr>\n";
		do {
			echo "<tr>";
			foreach ($array as $key => $value) {
				if (!is_numeric($key)) {
					$value = htmlspecialchars($value);
					if ($format_function[$key] != null) {
						$value = $format_function[$key]($value, $array);
					}					
					echo '<td>'. $value .'</td>';
				}
			}
			$n_res++;
			echo "</tr>\n";
		} while ($array = exam_fetch_array($result));
		echo "</table>";
		echo "<p>Total: " . $n_res . " Record(s).</p>";
	} else {
		echo "No record found.";
	}
}
?>
