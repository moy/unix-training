<?php
defined('_VALID_INCLUDE') or die('Direct access not allowed.');

session_name($exam_php_session);
session_start();

// Should never actually be used, but we need them to be set to avoid
// PHP errors.
$subject = 'N/A';
$session = 'N/A';

if (isset($_GET['reset'])) {
	$_SESSION['demo_questions'] = NULL;
	header('Location: index.php');
	die("Redirecting");
}

include_once './inc/demo-questions.php';
if (!isset($_SESSION['demo_questions'])) {
	$i = 0;
	foreach($demo_questions as $key => $value) {
		$demo_questions[$key]['question'] = $key;
		$demo_questions[$key]['student_answer'] = NULL;
	}
	$_SESSION['demo_questions'] = $demo_questions;
}



function get_exam_info($subject) {
	$points = 0;
	foreach($_SESSION['demo_questions'] as $line) {
		$points += $line['coeff'];
	}
	$demo_info = array('desc' => 'Demo',
			   'count' => count($_SESSION['demo_questions']),
			   'points' => $points);
	return $demo_info;
}

function get_questions ($machine, $session, $subject, $hide_correct = False) {
	$questions = array();
	foreach ($_SESSION['demo_questions'] as $n => $line) {
		$line['question'] = $n;
		if (!$hide_correct ||
		    must_be_shown($line, $machine, $session, $subject)) {
			$questions[] = $line;
		}
	}
	return $questions;
}

function get_form_array($question, $machine, $session, $subject) {
	global $demo_forms;
	if (isset($demo_forms[$question]) ||
	    $demo_forms[$question] != "") {
		return $demo_forms[$question];
	} else {
		return null;
	}
}

function get_login ($machine, $session, $subject) {
	return array('login' => "guest", 'first_name' => "guest", 'familly_name' => "",
		     'student_id' => 'N/A');
}

function set_answer($answer, $machine, $session, $subject, $question) {
	$_SESSION['demo_questions'][$question]['student_answer'] = $answer;
}

function get_answer($question, $machine, $session, $subject) {
	return $_SESSION['demo_questions'][$question];
}
