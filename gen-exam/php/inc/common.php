<?php
defined('_VALID_INCLUDE') or die('Direct access not allowed.');
// Uncomment for debugging
//ini_set('display_errors', 'On');error_reporting(E_ALL);

// In case register_globals is active (useless with recent enough PHP
// versions, but who knows), unset variables tested with isset()
// later. Must come before including config.php.
unset($exam_footer_include);
unset($lang);
unset($mode);

// Disable magic quotes
if (get_magic_quotes_gpc()) {
	function stripslashes_gpc(&$value)
	{
		$value = stripslashes($value);
	}
	array_walk_recursive($_GET, 'stripslashes_gpc');
	array_walk_recursive($_POST, 'stripslashes_gpc');
	array_walk_recursive($_COOKIE, 'stripslashes_gpc');
	array_walk_recursive($_REQUEST, 'stripslashes_gpc');
}

function exam_header($title = '', $basedir = '.') {
	echo '<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Matthieu Moy" />
	<title>'. $title .'</title>
	<style type="text/css">
	@import "'. htmlspecialchars($basedir) .'/style.css";
	</style>
	<script src="'. htmlspecialchars($basedir) .'/sorttable.js"></script>
</head>
<body>
';
	  if ($title != '') {
		  echo "<h1>$title</h1>";
	  }
}

// Very basic internationalization (avoid external dependency for such
// simple thing)
$exam_i18n = array(
	'fr' => array(
		'submit' => 'Soumettre',
		'demo_warning' => 'Attention ! Vous utilisez le mode « demo », rien ne sera enregistré dans la base de données',
		'reset_answers' => "Réinitialiser les réponses",
		'correct_answer' => "Réponse correcte validée",
		'retry' => "Réessayer",
		'login' => "Utilisateur (login)",
		'student_id' => "Numéro d'étudiant",
		'name' => "Nom",
		'machine' => "Machine",
		'session' => "Session",
		'questions' => "questions",
		'points' => "points",
		'display_correct' => "Afficher les réponses correctes",
		'hide_correct' => "Masquer les réponses correctes",
		'all_ok' => "Toutes les réponses ont été validées, félicitations !",
		'download_subject_here' => 'Vous pouvez télécharger ou re-télécharger les fichiers nécessaires pour répondre ici : ',
		'answer_validated' => 'Reponse validée. Cliquez à nouveau sur un bouton pour changer votre réponse.',
		'click_to_answer' => 'Cliquez sur un bouton pour valider la réponse'
		),
	
	'en' => array(
		'submit' => 'Submit',
		'demo_warning' => "Warning: You're running in demo mode. Nothing will be recorded in the database",
		'reset_answers' => "Reset Answers",
		'correct_answer' => "Correct answer validated",
		'retry' => "Retry",
		'login' => "Login",
		'student_id' => 'Student ID',
		'name' => "Name",
		'machine' => "Machine",
		'session' => "Session",
		'questions' => "questions",
		'points' => "points",
		'display_correct' => "Display correct answers",
		'hide_correct' => "Hide correct answers",
		'all_ok' => "All answers validated, congratulation!",
		'download_subject_here' => 'You may download or re-download the files needed to answer here: ',
		'answer_validated' => 'Answer validated. Click again on one of the buttons to change your answer.',
		'click_to_answer' => 'Click on any button to answer'
		)
	);

function exam_get_string($id) {
	global $exam_i18n;
	global $lang;
	if (!isset($lang)) {
		$lang = 'fr';
	}
	if (isset($exam_i18n[$lang][$id])) {
		return $exam_i18n[$lang][$id];
	} else {
		return $id;
	}
}

function exam_footer() {
	echo '</body></html>';
}

// Useful in $exam_footer_include for example. Returns
// ('current' => points, 'total' => total points)
function all_answers_summary() {
	$current_points = 0;
	$total_points = 0;
	global $machine, $session, $subject;
	foreach (get_questions($machine, $session, $subject) as $line) {
		if ($line["student_answer"] == $line["correct_answer"]) {
			$current_points += $line["coeff"];
		}
		$total_points += $line["coeff"];
	}
	return array('current' => $current_points, 'total' => $total_points);
}

if (isset($_GET["question"])) {
	$question = $_GET["question"];
} else {
	unset($question);
}

if (isset($question) && !is_numeric($question)) {
	unset($question);
}

//$machine = $_GET["machine"];
if (isSet($_SERVER["HTTP_X_FORWARDED_FOR"])) {
	$IP = $_SERVER["HTTP_X_FORWARDED_FOR"];
} else {
	$IP = $_SERVER["REMOTE_ADDR"];
}
$machine = gethostbyaddr($IP);

$subject_basename = 'sujet.tar.gz';
$subject_mimetype = 'application/x-gzip';

include_once('./inc/config.php');

// Must come after config.php ($subject_basename may have changed)
$subject_filename = 'subjects/'. $session .'/'. $machine .'/' . $subject_basename;
function subject_file_exists() {
	global $subject_filename;
	return file_exists($subject_filename);
}

if (isset($_GET["answer"])) {
	$answer = trim($_GET["answer"]);
} else {
	unset($answer);
}

if (!isset($mode)) {
	$mode = "sql";
}

function echo_correct($path) {
	echo '<span><img class="invisible" src="'. $path .'/ok.png" width="15px" height="15px" alt="ok" />&nbsp;'. exam_get_string('correct_answer') .'</span>';
}

function echo_incorrect($path) {
	echo '<span><img class="invisible" src="'. $path .'/ko.png" width="15px" height="15px" alt="ko" />&nbsp;</span>';
}

function check_numeric($var) {
	if (!isset($GLOBALS[$var])) {
		die('$'. $var .' is not set.');
	}
	if (!is_numeric($GLOBALS[$var])) {
		die('$'. $var .' is not numeric.');
	}
}

function check_nonempty($var) {
	if (!isset($GLOBALS[$var])) {
		die('$'. $var .' is not set.');
	}
	if ($GLOBALS[$var] === '') {
		die('$'. $var .' is empty.');
	}
}

// Do NOT hide correct MCQ entries, that would be too easy!
// Questions must be shown if either they haven't been answered
// properly or they are MCQ.
function must_be_shown($line, $machine, $session, $subject) {
	return !(isset($line['student_answer'])) ||
		$line['student_answer'] != $line['correct_answer'] ||
		get_form_array($line['question'], $machine, $session, $subject) != null;
}
	

if ($mode == "demo") {
	include_once './inc/common-demo.php';
} else {
	check_numeric('subject');
	check_numeric('session');
	check_nonempty('machine');
	include_once './inc/common-sql.php';
}